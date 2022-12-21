package def_monitor is

    protected type MaitreMonitor is
        -- Encontrar el salón donde se encuentra una persona
        function getSalon (nombre : String; tipo : Natural) return Natural;
        -- Devuelve el primer salón disponible dependiendo del tipo de cliente
        --function getSalonDisponible (tipo : Natural) return Natural;
        -- Devuelve la capcidad máxima que puede tomar el restaurante con respecto al tipo de cliente (fumador/no fumador)
        --function getCapacidad (tipo : Natural) return Natural;
        entry pedirMesa (tipo : Natural);   -- Entrar al restaurante
        entry pedirCuenta (tipo : Natural); -- Salir del restaurante

        -- Estructura de datos para gestionar los salones
        type Salon is record
            numSalon   : Natural;   -- Identificador del salón
            numMesas   : Natural;   -- Número de mesas del salón
            numMesasOc : Natural;   -- Número de mesas ocupadas
            tipoSalon  : Natural;   -- Tipo de salón (fumador/no fumador)
            clientes   : array (Natural range <>) of String; -- Clientes que se encuentran en el salón
        end record;

    private
        maxMesas    : Natural := 3;
        maxSalones  : Natural := 3;
        --salones    : array (Natural range <>) of Natural := (0, 0, 0);
        numMesas    : Natural := 0;
        --numSalones : Natural := 0;
        numClientes : Natural := 0;

    end MaitreMonitor;

end def_monitor;
