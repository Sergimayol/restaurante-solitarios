with Ada.Text_IO; use Ada.Text_IO;

package body def_monitor is

    protected body MaitreMonitor is

        function getSalon (nombre : String; tipo : Natural) return Natural is
        begin
            return 0;
        end getSalon;

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
