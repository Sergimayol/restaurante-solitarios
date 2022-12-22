with Ada.Text_IO; use Ada.Text_IO;

package body def_monitor is

    protected body MaitreMonitor is

        function getSalon (nombre : String; tipo : Natural) return Integer is
        begin
            for i in 1 .. maxSalones loop -- Por cada salón
                -- Si el salón actual es del tipo que se busca,
                -- se procede a buscar en el salón
                if salones (i).tipoSalon = tipo then
                    for j in 1 .. salones (i).numMesas loop -- Por cada mesa
                        -- Si el nombre del cliente es igual al que se busca,
                        -- se retorna el salón
                        if salones (i).clientes (j) = nombre then
                            return i;
                        end if;
                    end loop;
                end if;
            end loop;
            -- Si no se encuentra el salón devuelve -1
            return -1;
        end getSalon;

        function getSalonDisponible (tipo : Natural) return Natural is
        begin
            return 0;
        end getSalonDisponible;

        function getCapacidad (tipo : Natural) return Natural is
        begin
            return 0;
        end getCapacidad;

        entry pedirMesa (tipo : Natural) when numMesas /= 0 is
        begin
            numMesas := numMesas - 1;
        end pedirMesa;

        entry pedirCuenta (tipo : Natural) when numMesas /= 0 is
        begin
            numMesas := numMesas + 1;
        end pedirCuenta;

    end MaitreMonitor;

end def_monitor;
