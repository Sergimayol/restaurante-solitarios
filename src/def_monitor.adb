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
          return salonDisponible : Natural := 0 do
            for i in Salones'Range loop
              if (Salones(i).tipoSalon = tipo or Salones(i).tipoSalon = Nada) 
                and Salones(i).numMesasOc /= Salones(i).numMesas then
                salonDisponible := Salones(i).numSalon;
              end if;
            end loop;
          end return;
        end getSalonDisponible;

        function getCapacidad (tipo : TipoSalonCliente) return Natural is
        begin
          return capacidad : Natural := 0 do
            for i in Salones'Range loop-- Por cada salón
              -- Si el tipo del salon es igual al del parámetro o no tiene
              -- tipo el salon implica que hay capacidad para el cliente
              if Salones(i).tipoSalon = tipo or Salones(i).tipoSalon = Nada then
                capacidad := capacidad + 1;
              end if;
            end loop;
          end return;
        end getCapacidad;

        -- Entrar cuando haya capacidad en un salón de mi tipo
        entry pedirMesa (for tipo in TipoSalonCliente) when getCapacidad(tipo) /= 0 is
        begin
          -- Asignarle una mesa del primer salón que haya de su tipo o vacio con mesa libre
          -- Cambiar el tipo del salón al tipo del cliente en caso de no tener
          -- Añadir el cliente al salón
          -- Aumentar el número de mesas ocupadas en el salón

          -- Variables para solo dar info a la hora de programar, borrar en entrega
          mesasLibres := mesasLibres - 1;
          --Put_Line("Quedan estas mesas: "&mesasLibres'Img);
          numClientes := numClientes + 1;
        end pedirMesa;

        procedure pedirCuenta (tipo : TipoSalonCliente; nombre : String) is
        begin
          -- Encontrar el salón donde se encuentra el cliente
          -- Disminuir el num de mesas ocupadas
          -- Quitar al cliente del salón
          -- En el caso de quedarse el salón vacio cambiar el tipo del salón a nada

          -- Variables para solo dar info a la hora de programar, borrar en entrega
          mesasLibres := mesasLibres + 1;
          --Put_Line("Quedan estas mesas: "&mesasLibres'Img);
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
