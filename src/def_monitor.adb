with Ada.Text_IO; use Ada.Text_IO;

package body def_monitor is

    protected body MaitreMonitor is

        function getSalon (nombre : String; tipo : TipoSalonCliente) return Integer is
        begin
            for i in Salones'Range loop -- Por cada salón
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

        function getSalonDisponible (tipo : TipoSalonCliente) return Natural is
        begin
            return 0;
        end getSalonDisponible;

        function getCapacidad (tipo : TipoSalonCliente) return Natural is
        begin
            return 0;
        end getCapacidad;

        -- Entraré cuando haya capacidad en un salón de mi tipo
        entry pedirMesa (tipo : TipoSalonCliente) when mesasLibres /= 0 is
        begin
          mesasLibres := mesasLibres - 1;
          Put_Line("Quedan estas mesas: "&mesasLibres'Img);
          numClientes := numClientes + 1;
        end pedirMesa;

        procedure pedirCuenta (tipo : TipoSalonCliente; nombre : String) is
        begin
          mesasLibres := mesasLibres + 1;
          Put_Line("Quedan estas mesas: "&mesasLibres'Img);
          numClientes := numClientes - 1;
        end pedirCuenta;

        procedure iniciarSalones is
        begin
          for i in salones'Range loop
            salones(i).numSalon := i;
          end loop;
        end iniciarSalones;

        procedure verSalones is
        begin
          for i in salones'Range loop
            Put_Line("Salón " &Integer'Image(i)& " es " &Integer'Image(salones(i).numSalon));
          end loop;
        end verSalones;

    end MaitreMonitor;

end def_monitor;
