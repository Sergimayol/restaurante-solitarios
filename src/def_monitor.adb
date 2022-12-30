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

        procedure addCliente(idSalonCliente : Integer; nombre : String) is
        begin
          for i in salones(idSalonCliente).clientes'Range loop -- Por cada cliente en el salón
            if salones(idSalonCliente).clientes(i) = "" then
              salones(idSalonCliente).clientes(i) := To_Unbounded_String(nombre);
              return; -- Acabar bucle
            end if;
          end loop;
        end addCliente;

        procedure borrarCliente(idSalonCliente : Integer; nombre : String) is
        begin
          for i in salones(idSalonCliente).clientes'Range loop -- Por cada cliente en el salón
            if salones(idSalonCliente).clientes(i) = nombre then
              salones(idSalonCliente).clientes(i) := To_Unbounded_String("");
            end if;
          end loop;
        end borrarCliente;

        function getCapacidad (tipo : TipoSalonCliente) return Natural is
        begin
          return capacidad : Natural := 0 do
            for i in Salones'Range loop-- Por cada salón
              -- Si el tipo del salon es igual al del parámetro o no tiene
              -- tipo el salon implica que hay capacidad para el cliente
              if Salones(i).tipoSalon = tipo or Salones(i).tipoSalon = Nada then
                capacidad := capacidad + (Salones(i).numMesas - Salones(i).numMesasOc);
              end if;
            end loop;
          end return;
        end getCapacidad;

        -- Entrar cuando haya capacidad en un salón de mi tipo
        entry pedirMesa (for tipo in TipoSalonCliente) (nombre : String) when getCapacidad(tipo) /= 0 is
          idSalonCliente : Integer := 0;
        begin
          -- Asignarle una mesa del primer salón que haya de su tipo o vacio con mesa libre
          idSalonCliente := getSalonDisponible(tipo);
          -- Cambiar el tipo del salón al tipo del cliente en caso de no tener
          if salones(idSalonCliente).tipoSalon = Nada then
            salones(idSalonCliente).tipoSalon := tipo;
          end if;
          -- Añadir el cliente al salón
          addCliente(idSalonCliente, nombre);
          -- Aumentar el número de mesas ocupadas en el salón
          salones(idSalonCliente).numMesasOc := salones(idSalonCliente).numMesasOc + 1;

          -- debugSalon(idSalonCliente);

          -- Imprimir mensaje de información
          if tipo = Fumador then
            Put_Line("---------- En " &nombre& " te taula al saló de " 
              & salones(idSalonCliente).tipoSalon'Img & salones(idSalonCliente).numSalon'Img);
          else
            Put_Line("********** En " &nombre& " te taula al saló de " 
              & salones(idSalonCliente).tipoSalon'Img & salones(idSalonCliente).numSalon'Img);
          end if;

          -- Variables para solo dar info a la hora de programar, borrar en entrega
          mesasLibres := mesasLibres - 1;
          --Put_Line("Quedan estas mesas: "&mesasLibres'Img);
          numClientes := numClientes + 1;
          --Put_Line("Num clientes = " &numClientes'Img);
        end pedirMesa;

        procedure pedirCuenta (tipo : TipoSalonCliente; nombre : String) is
          idSalonCliente : Integer := 0;
          mesasDisponiblesSalon : Integer := 0;
        begin
          -- Encontrar el salón donde se encuentra el cliente
          idSalonCliente := getSalon(nombre, tipo);
          -- Disminuir el num de mesas ocupadas
          salones(idSalonCliente).numMesasOc := salones(idSalonCliente).numMesasOc - 1;
          -- Quitar al cliente del salón
          borrarCliente(idSalonCliente, nombre);
          -- En el caso de quedarse el salón vacio cambiar el tipo del salón a nada
          if salones(idSalonCliente).numMesasOc = 0 then
            salones(idSalonCliente).tipoSalon := Nada;
          end if;

          -- debugSalon(idSalonCliente);

          -- Imprimir mensaje de información
          mesasDisponiblesSalon := salones(idSalonCliente).numMesas - salones(idSalonCliente).numMesasOc;
          if tipo = Fumador then
            Put_Line("---------- En " &nombre& " allibera una taula del saló " & 
              salones(idSalonCliente).numSalon'Img & ". Disponibilitat: " &
              mesasDisponiblesSalon'Img &
              " Tipus: " & salones(idSalonCliente).tipoSalon'Img);
          else
            Put_Line("---------- En " &nombre& " allibera una taula del saló " & 
              salones(idSalonCliente).numSalon'Img & ". Disponibilitat: " &
              mesasDisponiblesSalon'Img &
              " Tipus: " & salones(idSalonCliente).tipoSalon'Img);
          end if;

          -- Variables para solo dar info a la hora de programar, borrar en entrega
          mesasLibres := mesasLibres + 1;
          --Put_Line("Quedan estas mesas: "&mesasLibres'Img);
          numClientes := numClientes - 1;
          --Put_Line("Num clientes = " &numClientes'Img);
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

        procedure debugSalon (id : Integer) is
          salonToDebug : Salon := salones(id);
        begin
          salonToDebug := salones(id);
          Put_Line("");
          Put_Line("Id salon =" &salonToDebug.numSalon'Img);
          Put_Line("numMesas =" &salonToDebug.numMesas'Img);
          Put_Line("numMesasOc =" &salonToDebug.numMesasOc'Img);
          Put_Line("tipoSalon=" &salonToDebug.tipoSalon'Img);
          Put_Line("clientes=[");
          for i in salonToDebug.clientes'Range loop
            Put_Line(i'Img& " ->" &salonToDebug.clientes(i));
          end loop;
          Put_Line("]");
          Put_Line("");
        end debugSalon;

    end MaitreMonitor;

end def_monitor;
