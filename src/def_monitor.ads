with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

package def_monitor is

    -- Tipos de salones
    type TipoSalonCliente is (Nada, Fumador, NoFumador);

    -- Array de clientes
    subtype IdxArrStr is Positive range Positive'First .. 3;
    type ArrStr is array (IdxArrStr) of Unbounded_String;

    -- Estructura de datos para gestionar los salones
    type Salon is tagged record
        numSalon   : Natural          := 0;     -- Identificador del salón
        numMesas   : Natural          := 3;     -- Número de mesas del salón
        numMesasOc : Natural          := 0;     -- Número de mesas ocupadas
        tipoSalon  : TipoSalonCliente := Nada;  -- Tipo Salón
        clientes   : ArrStr;                    -- Clientes que se encuentran en el salón
    end record;

    -- Array de salones
    type ArrsSalon is array (Integer range <>) of Salon;

    -- Monitor para gestionar el restaurante
    protected type MaitreMonitor is
        -- Encontrar el salón donde se encuentra una persona
        -- 0 si no lo encuentra
        -- 1..N si lo encuentra
        function getSalon (nombre : String; tipo : TipoSalonCliente) return Natural;
        -- Devuelve el numSalon primer salón disponible dependiendo del tipo de cliente
        -- 0 si no lo encuentra
        -- 1..N si lo encuentra
        function getSalonDisponible (tipo : TipoSalonCliente) return Natural;
        -- Devuelve la capcidad máxima que puede tomar el restaurante con respecto 
        -- al tipo de cliente (fumador/no fumador)
        function getCapacidad (tipo : TipoSalonCliente) return Natural;
        -- Entrar al restaurante
        entry pedirMesa (TipoSalonCliente) (nombre : in String);
        -- Salir del restaurante
        procedure pedirCuenta (tipo : TipoSalonCliente; nombre : String);
        -- Iniciar lista de salones
        procedure iniciarSalones; 
        -- Añade un cliente a un salón
        procedure addCliente (idSalonCliente : Integer; nombre : String);
        -- Elimina el cliente de un salón
        procedure borrarCliente (idSalonCliente : Integer; nombre : String);
        -- Funciones para debuger el programa
        procedure debugSalon (id : Integer);
        procedure verSalones;

    private
        numClientes : Natural := 0;     -- Num clientes
        mesasLibres : Natural := 9;     -- 3 salones de 3 mesas cada uno
        salones     : ArrsSalon(1..3);  -- Salones del restaurante

    end MaitreMonitor;

end def_monitor;
