with ada.text_io; use ada.text_io;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams;
use type Ada.Streams.Stream_Element_Count;

procedure main is
	
	targetURI : constant String := "";
	isOver : boolean := false;
	choice : String := "";
	
	procedure initiate_connection is
		address : sock_addr_type;
		client: Socket_Type;
		channel: Stream_Access;

		Send   : String := (1 => ASCII.CR, 2 => ASCII.LF, 3 => ASCII.CR, 4 => ASCII.LF);
   		Offset : Ada.Streams.Stream_Element_Count;
   		Data   : Ada.Streams.Stream_Element_Array (1 .. 256);

	begin
		GNAT.Sockets.Initialize;
		Create_Socket (Client);
		-- Address.Addr := Inet_Addr("203.66.88.89");
		Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1); -- host address
		Address.Port := 2345;

		Connect_Socket (Client, Address);
  		Channel := Stream (Client);

  		String'Write (Channel, "GET / HTTP/1.1" & Send);
	   loop
	      Ada.Streams.Read (Channel.All, Data, Offset);
	      exit when Offset = 0;
	      for I in 1 .. Offset loop
	         Ada.Text_IO.Put (Character'Val (Data (I)));
	      end loop;
	   end loop;

	end initiate_connection;

	procedure showMenu is
	begin
		put_line("Welcome to the DDOS attack control center");
		if (targetURI /= "") then
			put_line("Current target is: ");
			put_line(targetURI);
		else
			put_line("Please specify a target to attack");
		end if;
		put_line("[0] Exit");
		put_line("[1] Enter new target");
		put_line("[2] Attack");
		put_line("[3] Check netbots status");
		-- put_line("Welcome to the ddos attack control center");
	end showMenu;

begin
	initiate_connection;
end main;