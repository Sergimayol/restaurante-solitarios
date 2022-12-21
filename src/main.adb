with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Task_Identification;  use Ada.Task_Identification;

with def_monitor; use def_monitor;

procedure Main is

   -- Constantes
   FicheroNombres : constant String := "nombres.txt";
   NumProcesos    : constant        := 7;
   NumFumadores   : constant        := NumProcesos;
   NumNoFumadores : constant        := NumProcesos;
   monitor        : MaitreMonitor;
   TipoFumador    : constant        := 1;
   TipoNoFumador  : constant        := 2;

   -- NoFumador
   task type Cliente is
      entry Start (Nombre : in Unbounded_String; Tipo : in Integer);
   end Cliente;

   task body Cliente is
      Id          : Unbounded_String;
      TipoCliente : Integer;
   begin
      accept Start (Nombre : in Unbounded_String; Tipo : in Integer) do
         Id          := Nombre;
         TipoCliente := Tipo;
      end Start;
      Put_Line ("BON DIA sóm en " & Id & " i sóm No fumador");
      monitor.pedirMesa (TipoCliente);
      Put_Line
        ("En " & Id & " diu: Prendré el menú del dia. Som al saló " &
         monitor.getSalon (To_String (Id), TipoCliente)'Img);
      delay 1.0;
      Put_Line ("En " & Id & " diu: Ja he dinat, el compte per favor");
      monitor.pedirCuenta (TipoCliente);
      Put_Line ("En " & Id & " SE'NVA");
   end Cliente;

   subtype Index_Noms is Positive range Positive'First .. NumProcesos;
   type Array_Noms is array (Index_Noms) of Unbounded_String;

   F           : File_Type;
   Nombres     : Array_Noms;
   -- Variables
   Fumadores   : array (1 .. NumFumadores) of Cliente;
   NoFumadores : array (1 .. NumNoFumadores) of Cliente;

begin
   Open (F, In_File, FicheroNombres);
   for I in Nombres'Range loop
      Nombres (I) := To_Unbounded_String (Get_Line (F));
   end loop;
   Close (F);
   Put_Line ("++++++++++ El Maître està preparat");
   Put_Line ("++++++++++ Hi ha salons amb capacitat de 3 comensals cada un");
   delay 1.0;
   for i in Fumadores'Range loop
      Fumadores (i).Start (Nombres (Array_Noms'First + i), TipoFumador);
   end loop;
   for i in NoFumadores'Range loop
      NoFumadores (i).Start (Nombres (Array_Noms'First + i), TipoNoFumador);
   end loop;
end Main;
