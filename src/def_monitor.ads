package def_monitor is

    -- Estructura de datos para gestionar los salones
    type Salon (Id : Natural) is record
        numSalon   : Natural := Id;     -- Identificador del salón
        numMesas   : Natural := 3;      -- Número de mesas del salón
        numMesasOc : Natural := 0;      -- Número de mesas ocupadas
        tipoSalon  : Natural :=
           0;   -- Tipo de salón (nada=0 / fumador=1 / no fumador=2)
        clientes   : array
           (1 .. numMesas) of String; -- Clientes que se encuentran en el salón
    end record;

    protected type MaitreMonitor is
        -- Encontrar el salón donde se encuentra una persona
        function getSalon (nombre : String; tipo : Natural) return Natural;
        -- Devuelve el primer salón disponible dependiendo del tipo de cliente
        function getSalonDisponible (tipo : Natural) return Natural;
        -- Devuelve la capcidad máxima que puede tomar el restaurante con respecto al tipo de cliente (fumador/no fumador)
        function getCapacidad (tipo : Natural) return Natural;
        entry pedirMesa (tipo : Natural);   -- Entrar al restaurante
        entry pedirCuenta (tipo : Natural); -- Salir del restaurante

    private
        maxMesas    : Natural := 3;
        maxSalones  : Natural := 3;
        numMesas    : Natural := 0;
        numClientes : Natural := 0;
        salones     : array (1 .. maxSalones) of Salon;

    end MaitreMonitor;

end def_monitor;
