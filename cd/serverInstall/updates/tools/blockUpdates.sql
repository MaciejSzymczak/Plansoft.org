CREATE OR REPLACE TRIGGER trg_block_parent_update
BEFORE UPDATE OF parent
ON planners
FOR EACH ROW
BEGIN
    -- sprawdzenie czy zmieniana jest wartość pola PARENT
    IF :OLD.parent <> :NEW.parent THEN

        -- jeśli użytkownik nie jest PLANNER -> blokada
        IF UPPER(USER) <> 'PLANNER' THEN
            Xxmsz_Tools.insertIntoEventLog('Pole PLANNERS.PARENT probowal zmienic uzytkownik:'||USER); 
            RAISE_APPLICATION_ERROR(
                -20001,
                'To pole moze zmieniac tylko PLANNER'
            );
        END IF;

    END IF;
END;
/