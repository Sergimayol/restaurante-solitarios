with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Task_Identification;  use Ada.Task_Identification;

with def_monitor; use def_monitor;

procedure Main is

  -- Constantes
  FicheroNombres : constant String := "nombres.txt";
  NumProcesos    : constant        := 14;
--   NumFumadores   : constant        := NumProcesos / 2;
--   NumNoFumadores : constant        := NumProcesos / 2;
  monitor : MaitreMonitor;

  -- Cliente
  task type Cliente is
    entry Start (Nombre : in Unbounded_String; Tipo : in TipoSalonCliente);
  end Cliente;

  task body Cliente is
    Id          : Unbounded_String;
    TipoCliente : TipoSalonCliente;
  begin
    accept Start (Nombre : in Unbounded_String; Tipo : in TipoSalonCliente) do
      Id          := Nombre;
      TipoCliente := Tipo;
    end Start;
    if TipoCliente = Fumador then
      Put_Line ("BON DIA sóm en " & Id & " i sóm " & TipoCliente'Img);
    else
      Put_Line ("     BON DIA sóm en " & Id & " i sóm " & TipoCliente'Img);
    end if;
    delay 1.0;
    monitor.pedirMesa (TipoCliente) (To_String (Id));
    if TipoCliente = Fumador then
      Put_Line
       ("En " & Id & " diu: Prendré el menú del dia. Som al saló " &
        monitor.getSalon (To_String (Id), TipoCliente)'Img);
    else
      Put_Line
       ("     En " & Id & " diu: Prendré el menú del dia. Som al saló " &
        monitor.getSalon (To_String (Id), TipoCliente)'Img);
    end if;
    delay 3.5;
    if TipoCliente = Fumador then
      Put_Line ("En " & Id & " diu: Ja he dinat, el compte per favor");
    else
      Put_Line ("     En " & Id & " diu: Ja he dinat, el compte per favor");
    end if;
    monitor.pedirCuenta (TipoCliente, To_String (Id));
    if TipoCliente = Fumador then
      Put_Line ("En " & Id & " SE'NVA");
    else
      Put_Line ("     En " & Id & " SE'NVA");
    end if;
  end Cliente;

  subtype Index_Noms is Positive range Positive'First .. NumProcesos;
  type Array_Noms is array (Index_Noms) of Unbounded_String;

  type ArrCliente is array (0 .. NumProcesos - 1) of Cliente;

  F        : File_Type;
  Nombres  : Array_Noms;
  -- Variables
  Clientes : ArrCliente;

begin
  Open (F, In_File, FicheroNombres);
  for I in Nombres'Range loop
    Nombres (I) := To_Unbounded_String (Get_Line (F));
  end loop;
  Close (F);
  Put_Line ("++++++++++ El Maître està preparat");
  monitor.iniciarSalones;  -- Iniciar salones con id correspondiente
  Put_Line ("++++++++++ Hi ha salons amb capacitat de 3 comensals cada un");
  delay 1.0;
  for i in Clientes'Range loop
    declare
      res : Integer := i mod 2;
    begin
      if res > 0 then
        Clientes (i).Start (Nombres (Array_Noms'First + i), Fumador);
      else
        Clientes (i).Start (Nombres (Array_Noms'First + i), NoFumador);
      end if;
      delay 0.5;
    end;
  end loop;
end Main;
