class Minion{
	var rol
	var estamina
	
	method cambiarRol(nuevoR){
		rol.cambiarRol()
		rol = nuevoR
	}
	
	method arreglarMaquina(maquina){
		if(self.puedeArreglar(maquina)){
			self.perderEstamina(2*maquina.complejidad())
		}else{
			self.error("no puede arreglar maquina")
		}
	}
	
	method perderEstamina(cant){
		estamina -= cant
	}
	
	method puedeArreglar(maquina){
		if(not maquina.requiereHerramientas){
			return maquina.complejidad() <= estamina
		}
		return rol.herramientasSuficientes(maquina)
	}
	

}

class Biclopes inherits Minion{
	const ojos = 2
	const limite = 10
	
}

class Ciclopes inherits Minion{
	const ojos = 1

}

/////////////////////////////////////////////////////////////////////////////////////
class Rol{
	method cambiarRol(){}
}

class Soldado inherits Rol{
	var practica = 0
	var practicaGanada = 0
	
	method usarArma(){
		self.aumentarPractica(2)
	}
	
	method aumentarPractica(cant){
		practica += cant
		practicaGanada += 2
	}
	
	override method cambiarRol(){
		practicaGanada = 0
	}
}

class Obrero inherits Rol{
	const cinturon = []
	method herramientas() = cinturon
	method herramientasSuficientes(maquina) = cinturon == maquina.herramientasReq()
}

class Mucama inherits Rol{
}

/////////////////////////////////////////////////////////////////////////////////////////

class Maquina{
	var dificultad = 2*complejidad
	var complejidad
	const herramientasRequeridas = []
	
	method herramientasReq() = herramientasRequeridas
	method complejidad() = complejidad
	
	method requiereHerramientas() = not herramientasRequeridas.isEmpty()
}
