require 'socket'

class Servidor

  def initialize(puerto, dir)
    @server = TCPServer.open(puerto, dir)

    @detallesConexion = Hash.new
    @clientesConectados = Hash.new  #hash con clave nombre de usuario y valor socket TCP

    @detallesConexion[:servidor] = @server  #hash con clave servidor(valor server TCP)
    @detallesConexion[:cliente] = @clientesConectados ## hash con clave clientes (valor es otro hash con los
                                                        #clientes conectados al servidor(socket TCP))

        #a medida que se llena el hash @detallesConexion con los valores de :clientes
        #se va agregando al @clientesConectados
        #se reinicia cuando se cierra el servidor
    run

  end

  def run
    loop{
        conexionCliente = @server.accept
        conexionCliente.puts "Holaaaa"
        nombre = conexionCliente.puts "Escriba su nombre de usuario: "
        Thread.new(conexionCliente) do |conexion|  #thread para cada conexion aceptada
          nombre = conexion.gets.chomp
          if(@detallesConexion[:cliente][nombre] !=nil) #rechazar conexion porque ese nombre ya existe en tabla hash
            conexion.puts "Nombre ya existe, conexion rechazada"
            conexion.kill
          end

         @detallesConexion[:cliente][nombre] = conexion

          conexion.puts "Conexion establecida usuario #{nombre.upcase} conexion: #{conexion}"

          # conexion.puts @clientesConectados
          #conexion.puts @detallesConexion
        opcion =  conexion.puts "Ingrese opcion que desee: \r\n
                          1- Chatear con otro usuario \r\n

                          2- Salir   \r\n   "

            Thread.new(conexionCliente) do |conexionn|
            opcion = conexion.gets.chomp.to_i

            @detallesConexion[nombre]= opcion  #add

          if(opcion == 2)
            conexion.puts "Cerrando..."
            conexion.kill
          else
            conexion.puts "Ya puede chatear:..."
              chatear(nombre, conexion)
         end
        end
      end
      }.join
    end


    def chatear(nombreUsuario, conexion1)
      loop do
        msg= conexion1.gets
        puts @detallesConexion[:cliente]
        (@detallesConexion[:cliente]).keys.each do |cliente|
          @detallesConexion[:cliente][cliente].puts "#{nombreUsuario.upcase}: #{msg} ---el #{Time.now}"

       end
    end
  end
end

Servidor.new("localhost",  2046)
