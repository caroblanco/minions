class Minion{
	var property rol
	var property estamina
	const maquina
	const sector
	const tareas = []
	
	method fuerza() = estamina/2 + 2 + rol.fuerza()
	
	method cambiarRol(nuevoR){
		rol.cambiarRol()
		rol = nuevoR
	}
	
	method perderEstamina(cant){
		estamina -= cant
	}
	
	method agregarEstamina(cant){
		estamina += cant
	}
	
	method comer(fruta){
		self.agregarEstamina(fruta.recupera())
	}
	
	method realizarTarea(tarea){
		rol.realizarTarea(tarea,self)
	}	
	
	method noMucama() = rol != mucama
	
	method fuerzaMayorA(cant) = self.fuerza() >= cant
	
	method estaminaReq(cant) = estamina <= cant
	
	method experiencia() = self.cantTareas() * self.dificultadesTareas()
	
	method dificultadesTareas() = tareas.sum({unaTar => unaTar.dificultades()}) 
	
	method cantTareas() = tareas.size()
	
	method agregarTarea(tarea){
		tareas.add(tarea)
	}

}

class Biclopes inherits Minion{
	const ojos = 2
	const limite = 10
	
}

class Ciclopes inherits Minion{
	const ojos = 1

	override method fuerza() = super() / 2 
}

/////////////////////////////////////////////////////////////////////////////////////
class Rol{
	method cambiarRol(){}
	method fuerza() = 0
	
	method realizarTarea(tarea,alguien){
		if(tarea.puedeRealizar(alguien)){
			tarea.realizar(alguien)
			alguien.agregarTarea(tarea)
		}else{
			self.error("NO SE PUDO REALIZAR LA TAREA")
		}
	}
}

object capataz inherits Rol{
	const empleados = []
	
	override method realizarTarea(tarea,alguien){
		const experimentado = empleados.max({unE => unE.experiencia()}) //ME DIO PAJA EL CONDICIONAL
		experimentado.realizarTarea(tarea)
	}
	
}

object soldado inherits Rol{
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
	
	override method fuerza() = practica
}

object obrero inherits Rol{
	const cinturon = []
	method herramientas() = cinturon
	method herramientasSuficientes(maquina) = cinturon == maquina.herramientasReq()
}

object mucama inherits Rol{
}

/////////////////////////////////////////////////////////////////////////////////////////

class ArreglarMaquina{
	const maquina
	var property dificultad = 2*maquina.complejidad()
	
	method realizar(alguien){
		alguien.perderEstamina(2*maquina.complejidad())
	}
	
	method puedeRealizar(alguien){
		if(not maquina.requiereHerramientas()){
			return maquina.complejidad() <= alguien.estamina()
		}
		return alguien.rol().herramientasSuficientes(maquina)
	}
}

class DefenderSector{
	const sector
	const gradoAmenaza 
	var property dificultad = gradoAmenaza //RARI: La dificultad de esta tarea es el grado de amenaza para los Bíclopes y el doble para los Cíclopes.
	
	
	method realizar(alguien){
		alguien.perderMitadEst()
	}
	
	method puedeRealizar(alguien) =alguien.noMucama() && alguien.fuerzaMayorA(gradoAmenaza)
	
}

class LimpiarUnSector{
	const sector
	var property dificultad = 10
	const esGrande
	
	method cambiarDif(cant){
		dificultad = cant
	}
	
	method realizar(alguien){
		if(esGrande && not alguien.esMucama()){
			alguien.perderEstamina(4)	
		}else if (not alguien.esMucama()){
			alguien.perderEstamina(1)
		}
	}
	
	method puedeRealizar(alguien){
		if(esGrande){
			alguien.estaminaReq(4)	
		}else{
			alguien.estaminaReq(1)
		}
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////////

class Maquina{

	var complejidad
	const herramientasRequeridas = []
	
	method herramientasReq() = herramientasRequeridas
	method complejidad() = complejidad
	
	method requiereHerramientas() = not herramientasRequeridas.isEmpty()
}

///////////////////////////////////////////////////////////////////////////////////////////

class Banana{
	method recupera() = 10
}

class Manzana{
	method recupera() = 5
}

class Uva{
	method recupera() = 1
}