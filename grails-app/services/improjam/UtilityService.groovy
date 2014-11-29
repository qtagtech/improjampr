package improjam



class UtilityService {

    def generateUserPassword(){

        def animals = ['perro','gato','sapo','raton','caballo','libelula','mariposa','leon','tigre','tigrillo','elefante','jirafa','buey','alce','mosca','zancudo','cerdo','vaca','toro','carnero','oveja','pollo','gallina'];
        def colors = ['negro','blanco','azul','amarillo','rojo','verde','gris','cafe','turquesa','morado','lila','vinotinto','naranja'];
        def propertiess = ['salton','feo','chillon','griton','loco','tierno','bonito','peludo','canson','jodido','volador','ladron','bueno','malo','triste','alegre','contento','enfadado','genial','gentil','leal','bonachon','dormilon'];
        return ""+animals[new Random().nextInt(animals.size())]+"_"+colors[new Random().nextInt(colors.size())]+"_"+propertiess[new Random().nextInt(propertiess.size())]+"_"+new Random().nextInt(3000)


    }
}
