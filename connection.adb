package body Connection is
	con: Connection;

	procedure write_to_socket (message: in String) is
	begin
		String'Write(con.channel, message);
	end write_to_socket;

	procedure initiate_connection (botAddress: in String; portNumber: in Port_Type) is
	begin
		GNAT.Sockets.Initialize;
		Create_Socket (con.client);
		con.address.Addr := Inet_Addr(botAddress);
		con.address.Port := portNumber;

		Connect_Socket (con.client, con.address);
		con.channel := Stream (con.client);

		String'Write(con.channel, "siema");

		Close_Socket (con.client);
	end initiate_connection;

begin
	null;
end Connection;
