unit UQRCode;

// QR Code generator (ISO/IEC 18004), byte mode, versions 1..40, error correction L/M/Q/H, automatic version and mask.
// Port of the algorithm of "QR Code generator library" by Project Nayuki (MIT License, https://www.nayuki.io/page/qr-code-generator-library).
// Used for the QR codes of rooms (Tworzenie witryny www | "Generuj barcody dla sal do pliku Barcody.docx").
// Delphi 7, no external libraries: the codes are drawn into a bitmap (QRCodeToBitmap).

interface

uses Windows, Types, SysUtils, Graphics;

const
  QR_ECC_LOW      = 0;
  QR_ECC_MEDIUM   = 1;
  QR_ECC_QUARTILE = 2;
  QR_ECC_HIGH     = 3;

type
  TQRMatrix = array of array of Boolean;   // [y][x], True = dark module

// QR code of the bytes of data (e.g. UTF8Encode(url)); size - number of modules per side. Raises an exception when too long.
function QREncodeBytes(const data : string; ecl : integer; var size : integer) : TQRMatrix;
// the QR code as a black and white bitmap: moduleSize pixels per module, quiet zone of quietModules modules
function QRCodeToBitmap(const data : string; ecl, moduleSize, quietModules : integer) : TBitmap;

implementation

const
  // ECC codewords per block and number of blocks [ecl][version] (index 0 unused)
  ECC_CODEWORDS_PER_BLOCK : array[0..3, 0..40] of integer = (
    (-1,  7, 10, 15, 20, 26, 18, 20, 24, 30, 18, 20, 24, 26, 30, 22, 24, 28, 30, 28, 28, 28, 28, 30, 30, 26, 28, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30),
    (-1, 10, 16, 26, 18, 24, 16, 18, 22, 22, 26, 30, 22, 22, 24, 24, 28, 28, 26, 26, 26, 26, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28),
    (-1, 13, 22, 18, 26, 18, 24, 18, 22, 20, 24, 28, 26, 24, 20, 30, 24, 28, 28, 26, 30, 28, 30, 30, 30, 30, 28, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30),
    (-1, 17, 28, 22, 16, 22, 28, 26, 26, 24, 28, 24, 28, 22, 24, 24, 30, 28, 28, 26, 28, 30, 24, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30));
  NUM_ERROR_CORRECTION_BLOCKS : array[0..3, 0..40] of integer = (
    (-1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 6, 6, 6, 6, 7, 8, 8, 9, 9, 10, 12, 12, 12, 13, 14, 15, 16, 17, 18, 19, 19, 20, 21, 22, 24, 25),
    (-1, 1, 1, 1, 2, 2, 4, 4, 4, 5, 5, 5, 8, 9, 9, 10, 10, 11, 13, 14, 16, 17, 17, 18, 20, 21, 23, 25, 26, 28, 29, 31, 33, 35, 37, 38, 40, 43, 45, 47, 49),
    (-1, 1, 1, 2, 2, 4, 4, 6, 6, 8, 8, 8, 10, 12, 16, 12, 17, 16, 18, 21, 20, 23, 23, 25, 27, 29, 34, 34, 35, 38, 40, 43, 45, 48, 51, 53, 56, 59, 62, 65, 68),
    (-1, 1, 1, 2, 4, 4, 4, 5, 6, 8, 8, 11, 11, 16, 16, 18, 16, 19, 21, 25, 25, 25, 34, 30, 32, 35, 37, 40, 42, 45, 48, 51, 54, 57, 60, 63, 66, 70, 74, 77, 81));
  // format bits of the error correction level (L, M, Q, H)
  ECC_FORMAT_BITS : array[0..3] of integer = (1, 0, 3, 2);

type
  TBytes = array of Byte;

var
  modules, isFunction : TQRMatrix;
  qrSize : integer;

// ------------------------------------------------------------------------------------------------ helpers
function getBit(x, i : integer) : Boolean;
begin
  result := ((x shr i) and 1) <> 0;
end;

function getNumRawDataModules(ver : integer) : integer;
var numAlign : integer;
begin
  result := (16 * ver + 128) * ver + 64;
  if ver >= 2 then begin
    numAlign := ver div 7 + 2;
    result := result - ((25 * numAlign - 10) * numAlign - 55);
    if ver >= 7 then result := result - 36;
  end;
end;

function getNumDataCodewords(ver, ecl : integer) : integer;
begin
  result := getNumRawDataModules(ver) div 8 - ECC_CODEWORDS_PER_BLOCK[ecl, ver] * NUM_ERROR_CORRECTION_BLOCKS[ecl, ver];
end;

// ------------------------------------------------------------------------------------------------ Reed-Solomon
function rsMultiply(x, y : integer) : integer;
var i, z : integer;
begin
  z := 0;
  for i := 7 downto 0 do begin
    z := ((z shl 1) xor ((z shr 7) * $11D)) and $FF;
    if ((y shr i) and 1) <> 0 then z := z xor x;
  end;
  result := z;
end;

function rsComputeDivisor(degree : integer) : TBytes;
var i, j, root : integer;
begin
  SetLength(result, degree);
  for i := 0 to degree - 1 do result[i] := 0;
  result[degree - 1] := 1;
  root := 1;
  for i := 0 to degree - 1 do begin
    for j := 0 to degree - 1 do begin
      result[j] := rsMultiply(result[j], root);
      if j + 1 < degree then result[j] := result[j] xor result[j + 1];
    end;
    root := rsMultiply(root, $02);
  end;
end;

function rsComputeRemainder(const data : TBytes; const divisor : TBytes) : TBytes;
var i, j, factor, n : integer;
begin
  n := Length(divisor);
  SetLength(result, n);
  for i := 0 to n - 1 do result[i] := 0;
  for i := 0 to High(data) do begin
    factor := data[i] xor result[0];
    for j := 0 to n - 2 do result[j] := result[j + 1];
    result[n - 1] := 0;
    for j := 0 to n - 1 do result[j] := result[j] xor rsMultiply(divisor[j], factor);
  end;
end;

// ------------------------------------------------------------------------------------------------ function patterns
procedure setFunctionModule(x, y : integer; isDark : Boolean);
begin
  modules[y][x] := isDark;
  isFunction[y][x] := true;
end;

function getAlignmentPatternPositions(ver : integer) : TBytes;
var numAlign, step, i, pos : integer;
begin
  if ver = 1 then begin SetLength(result, 0); exit; end;
  numAlign := ver div 7 + 2;
  if ver = 32 then step := 26
  else step := ((ver * 4 + numAlign * 2 + 1) div (numAlign * 2 - 2)) * 2;
  SetLength(result, numAlign);
  result[0] := 6;
  pos := ver * 4 + 17 - 7;
  for i := numAlign - 1 downto 1 do begin
    result[i] := pos;
    pos := pos - step;
  end;
end;

procedure drawFinderPattern(x, y : integer);
var dx, dy, dist, xx, yy : integer;
begin
  for dy := -4 to 4 do
    for dx := -4 to 4 do begin
      dist := abs(dx); if abs(dy) > dist then dist := abs(dy);
      xx := x + dx; yy := y + dy;
      if (xx >= 0) and (xx < qrSize) and (yy >= 0) and (yy < qrSize) then
        setFunctionModule(xx, yy, (dist <> 2) and (dist <> 4));
    end;
end;

procedure drawAlignmentPattern(x, y : integer);
var dx, dy, dist : integer;
begin
  for dy := -2 to 2 do
    for dx := -2 to 2 do begin
      dist := abs(dx); if abs(dy) > dist then dist := abs(dy);
      setFunctionModule(x + dx, y + dy, dist <> 1);
    end;
end;

procedure drawFormatBits(ecl, mask : integer);
var data, rem, bits, i : integer;
begin
  data := (ECC_FORMAT_BITS[ecl] shl 3) or mask;
  rem := data;
  for i := 0 to 9 do rem := (rem shl 1) xor ((rem shr 9) * $537);
  bits := ((data shl 10) or (rem and $3FF)) xor $5412;
  // first copy
  for i := 0 to 5 do setFunctionModule(8, i, getBit(bits, i));
  setFunctionModule(8, 7, getBit(bits, 6));
  setFunctionModule(8, 8, getBit(bits, 7));
  setFunctionModule(7, 8, getBit(bits, 8));
  for i := 9 to 14 do setFunctionModule(14 - i, 8, getBit(bits, i));
  // second copy
  for i := 0 to 7 do setFunctionModule(qrSize - 1 - i, 8, getBit(bits, i));
  for i := 8 to 14 do setFunctionModule(8, qrSize - 15 + i, getBit(bits, i));
  setFunctionModule(8, qrSize - 8, true);   // always dark
end;

procedure drawVersion(ver : integer);
var rem, bits, i, a, b : integer;
    bit : Boolean;
begin
  if ver < 7 then exit;
  rem := ver;
  for i := 0 to 11 do rem := (rem shl 1) xor ((rem shr 11) * $1F25);
  bits := (ver shl 12) or (rem and $FFF);
  for i := 0 to 17 do begin
    bit := getBit(bits, i);
    a := qrSize - 11 + i mod 3;
    b := i div 3;
    setFunctionModule(a, b, bit);
    setFunctionModule(b, a, bit);
  end;
end;

procedure drawFunctionPatterns(ver, ecl : integer);
var i, j, numAlign : integer;
    pos : TBytes;
begin
  for i := 0 to qrSize - 1 do begin
    setFunctionModule(6, i, i mod 2 = 0);
    setFunctionModule(i, 6, i mod 2 = 0);
  end;
  drawFinderPattern(3, 3);
  drawFinderPattern(qrSize - 4, 3);
  drawFinderPattern(3, qrSize - 4);
  pos := getAlignmentPatternPositions(ver);
  numAlign := Length(pos);
  for i := 0 to numAlign - 1 do
    for j := 0 to numAlign - 1 do
      if not (((i = 0) and (j = 0)) or ((i = 0) and (j = numAlign - 1)) or ((i = numAlign - 1) and (j = 0))) then
        drawAlignmentPattern(pos[i], pos[j]);
  drawFormatBits(ecl, 0);   // dummy mask, overwritten later
  drawVersion(ver);
end;

// ------------------------------------------------------------------------------------------------ codewords
function addEccAndInterleave(const data : TBytes; ver, ecl : integer) : TBytes;
var numBlocks, blockEccLen, rawCodewords, numShortBlocks, shortBlockLen : integer;
    blocks : array of TBytes;
    divisor, dat, ecc : TBytes;
    i, j, k, len, n : integer;
begin
  numBlocks      := NUM_ERROR_CORRECTION_BLOCKS[ecl, ver];
  blockEccLen    := ECC_CODEWORDS_PER_BLOCK[ecl, ver];
  rawCodewords   := getNumRawDataModules(ver) div 8;
  numShortBlocks := numBlocks - rawCodewords mod numBlocks;
  shortBlockLen  := rawCodewords div numBlocks;
  divisor := rsComputeDivisor(blockEccLen);
  SetLength(blocks, numBlocks);
  k := 0;
  for i := 0 to numBlocks - 1 do begin
    len := shortBlockLen - blockEccLen;
    if i >= numShortBlocks then inc(len);
    SetLength(dat, len);
    for j := 0 to len - 1 do dat[j] := data[k + j];
    k := k + len;
    ecc := rsComputeRemainder(dat, divisor);
    // block: data (+ a dummy byte in short blocks) + ecc
    SetLength(blocks[i], shortBlockLen + 1);
    for j := 0 to len - 1 do blocks[i][j] := dat[j];
    n := len;
    if i < numShortBlocks then begin blocks[i][n] := 0; inc(n); end;
    for j := 0 to blockEccLen - 1 do blocks[i][n + j] := ecc[j];
  end;
  SetLength(result, rawCodewords);
  n := 0;
  for i := 0 to shortBlockLen do
    for j := 0 to numBlocks - 1 do
      if (i <> shortBlockLen - blockEccLen) or (j >= numShortBlocks) then begin
        result[n] := blocks[j][i];
        inc(n);
      end;
end;

procedure drawCodewords(const data : TBytes);
var i, right, vert, j, x, y : integer;
    upward : Boolean;
begin
  i := 0;
  right := qrSize - 1;
  while right >= 1 do begin
    if right = 6 then right := 5;
    for vert := 0 to qrSize - 1 do
      for j := 0 to 1 do begin
        x := right - j;
        upward := ((right + 1) and 2) = 0;
        if upward then y := qrSize - 1 - vert else y := vert;
        if (not isFunction[y][x]) and (i < Length(data) * 8) then begin
          modules[y][x] := getBit(data[i shr 3], 7 - (i and 7));
          inc(i);
        end;
      end;
    right := right - 2;
  end;
end;

procedure applyMask(mask : integer);
var x, y : integer;
    invert : Boolean;
begin
  for y := 0 to qrSize - 1 do
    for x := 0 to qrSize - 1 do begin
      case mask of
        0: invert := (x + y) mod 2 = 0;
        1: invert := y mod 2 = 0;
        2: invert := x mod 3 = 0;
        3: invert := (x + y) mod 3 = 0;
        4: invert := (x div 3 + y div 2) mod 2 = 0;
        5: invert := (x * y mod 2 + x * y mod 3) = 0;
        6: invert := (x * y mod 2 + x * y mod 3) mod 2 = 0;
      else invert := ((x + y) mod 2 + x * y mod 3) mod 2 = 0;
      end;
      if (not isFunction[y][x]) and invert then modules[y][x] := not modules[y][x];
    end;
end;

// penalty of the symbol: runs (N1), 2x2 blocks (N2), finder-like patterns (N3), dark/light balance (N4).
// The mask only makes the code easier to read - every mask gives a valid code.
function getPenaltyScore : integer;
const pat1 : array[0..10] of Boolean = (true, false, true, true, true, false, true, false, false, false, false);
      pat2 : array[0..10] of Boolean = (false, false, false, false, true, false, true, true, true, false, true);
var x, y, dark, total, k : integer;
    color : Boolean;
    score : integer;
  function m(horizontal : Boolean; a, b : integer) : Boolean;
  begin
    if horizontal then result := modules[a][b] else result := modules[b][a];
  end;
  procedure lines(horizontal : Boolean);
  var a, b, i, run : integer;
      c, ok1, ok2 : Boolean;
  begin
    for a := 0 to qrSize - 1 do begin
      run := 0;
      c := false;
      for b := 0 to qrSize - 1 do begin
        if (b > 0) and (m(horizontal, a, b) = c) then begin
          inc(run);
          if run = 5 then inc(score, 3) else if run > 5 then inc(score);
        end else begin
          c := m(horizontal, a, b);
          run := 1;
        end;
      end;
      for b := 0 to qrSize - 11 do begin
        ok1 := true; ok2 := true;
        for i := 0 to 10 do begin
          if m(horizontal, a, b + i) <> pat1[i] then ok1 := false;
          if m(horizontal, a, b + i) <> pat2[i] then ok2 := false;
        end;
        if ok1 then inc(score, 40);
        if ok2 then inc(score, 40);
      end;
    end;
  end;
begin
  score := 0;
  lines(true);
  lines(false);
  for y := 0 to qrSize - 2 do
    for x := 0 to qrSize - 2 do begin
      color := modules[y][x];
      if (color = modules[y][x + 1]) and (color = modules[y + 1][x]) and (color = modules[y + 1][x + 1]) then inc(score, 3);
    end;
  dark := 0;
  for y := 0 to qrSize - 1 do
    for x := 0 to qrSize - 1 do
      if modules[y][x] then inc(dark);
  total := qrSize * qrSize;
  // smallest k such that (45-5k)% <= dark/total <= (55+5k)%
  k := (abs(dark * 20 - total * 10) + total - 1) div total - 1;
  if k > 0 then inc(score, k * 10);
  result := score;
end;

// ------------------------------------------------------------------------------------------------ encoding
function QREncodeBytes(const data : string; ecl : integer; var size : integer) : TQRMatrix;
var ver, capBits, usedBits, ccBits, i, j, mask, bestMask, bestPenalty, penalty, capBytes : integer;
    bits : array of Boolean;
    nb : integer;
    codewords : TBytes;
  procedure appendBits(val, len : integer);
  var k : integer;
  begin
    for k := len - 1 downto 0 do begin
      if nb >= Length(bits) then SetLength(bits, Length(bits) * 2 + 64);
      bits[nb] := ((val shr k) and 1) <> 0;
      inc(nb);
    end;
  end;
begin
  // the smallest version which holds the data
  ver := 0;
  for i := 1 to 40 do begin
    if i <= 9 then ccBits := 8 else ccBits := 16;
    usedBits := 4 + ccBits + Length(data) * 8;
    if usedBits <= getNumDataCodewords(i, ecl) * 8 then begin ver := i; break; end;
  end;
  if ver = 0 then raise Exception.Create('QR: zbyt d³ugi tekst ('+IntToStr(Length(data))+' bajtów)');
  if ver <= 9 then ccBits := 8 else ccBits := 16;

  // data bits: mode byte (0100), count, bytes, terminator, padding
  nb := 0;
  SetLength(bits, 0);
  appendBits(4, 4);
  appendBits(Length(data), ccBits);
  for i := 1 to Length(data) do appendBits(Ord(data[i]), 8);
  capBytes := getNumDataCodewords(ver, ecl);
  capBits := capBytes * 8;
  j := capBits - nb; if j > 4 then j := 4;
  appendBits(0, j);
  appendBits(0, (8 - nb mod 8) mod 8);
  i := 0;
  while nb < capBits do begin
    if i mod 2 = 0 then appendBits($EC, 8) else appendBits($11, 8);
    inc(i);
  end;
  SetLength(codewords, capBytes);
  for i := 0 to capBytes - 1 do begin
    codewords[i] := 0;
    for j := 0 to 7 do
      if bits[i * 8 + j] then codewords[i] := codewords[i] or (1 shl (7 - j));
  end;
  codewords := addEccAndInterleave(codewords, ver, ecl);

  // the symbol
  qrSize := ver * 4 + 17;
  SetLength(modules, qrSize, qrSize);
  SetLength(isFunction, qrSize, qrSize);
  for i := 0 to qrSize - 1 do
    for j := 0 to qrSize - 1 do begin modules[i][j] := false; isFunction[i][j] := false; end;
  drawFunctionPatterns(ver, ecl);
  drawCodewords(codewords);

  // the mask with the smallest penalty
  bestMask := 0;
  bestPenalty := MaxInt;
  for mask := 0 to 7 do begin
    applyMask(mask);
    drawFormatBits(ecl, mask);
    penalty := getPenaltyScore;
    if penalty < bestPenalty then begin bestMask := mask; bestPenalty := penalty; end;
    applyMask(mask);   // undo (xor)
  end;
  applyMask(bestMask);
  drawFormatBits(ecl, bestMask);

  size := qrSize;
  SetLength(result, qrSize, qrSize);
  for i := 0 to qrSize - 1 do
    for j := 0 to qrSize - 1 do result[i][j] := modules[i][j];
end;

function QRCodeToBitmap(const data : string; ecl, moduleSize, quietModules : integer) : TBitmap;
var m : TQRMatrix;
    size, x, y, px : integer;
begin
  m := QREncodeBytes(data, ecl, size);
  px := (size + 2 * quietModules) * moduleSize;
  result := TBitmap.Create;
  result.PixelFormat := pf24bit;
  result.Width  := px;
  result.Height := px;
  result.Canvas.Brush.Color := clWhite;
  result.Canvas.FillRect(Rect(0, 0, px, px));
  result.Canvas.Brush.Color := clBlack;
  for y := 0 to size - 1 do
    for x := 0 to size - 1 do
      if m[y][x] then
        result.Canvas.FillRect(Rect((x + quietModules) * moduleSize, (y + quietModules) * moduleSize,
                                    (x + quietModules + 1) * moduleSize, (y + quietModules + 1) * moduleSize));
end;

end.
