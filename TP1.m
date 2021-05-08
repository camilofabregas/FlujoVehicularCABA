# Trabajo Práctico 1 - Grupo 17 - Modelación Númerica - 1er cuatrimestre 2021

#Item a.
datos = load('FlujoVehicular2019.dat'); # Lee el conjunto de datos del archivo.

#------------------------------------------------------

#FUNCIONES

# Recibe una tabla de datos y va calculando el balance para cada hora.
function balPorHora = balancePorHora(tabla)
  
  balPorHora = zeros(24,1);
  
  for i = 1:rows(tabla)
    balPorHora = acumularBalancesPorHora(tabla,i,balPorHora);
  endfor
  
endfunction

# Recibe una tabla de datos y va calculando el balance para cada hora en una
# estación específica.
function balPorHora = balanceEstacionPorHora(tabla,estacion)
  
  balPorHora = zeros(24,1);
  
  for i = 1:rows(tabla)
    if(tabla(i,5) == estacion)
      balPorHora = acumularBalancesPorHora(tabla,i,balPorHora);
    endif
  endfor
  
endfunction

# Acumula balances por hora en un vector y lo devuelve.
function balPorHora = acumularBalancesPorHora(tabla,i,balancesPorHora)
  
  balPorHora = balancesPorHora;
  
  if(tabla(i,6) == 1) #Si es ingreso.
    balPorHora(tabla(i,3)+1) += tabla(i,9); #Sumo cantidad de pasos a la hora.
  else #Si es egreso.
    balPorHora(tabla(i,3)+1) -= tabla(i,9); #Resto cantidad de pasos a la hora.
  endif
  
endfunction

# Busca y devuelve la estación de peaje con mayor cantidad de pasos totales.
function estacion = mayorCantPasos(datos)
  
  pasosPorEstacion = zeros(8,1);
  
  for i = 1:rows(datos)
    pasosPorEstacion(datos(i,5)) += datos(i,9); #Acumula pasos para c/estación.
  endfor
  
  cantPasos = 0;
  
  for j = 1:8
    if(pasosPorEstacion(j)>cantPasos) #Busca estacion con mayor cant. de pasos.
      cantPasos = pasosPorEstacion(j);
      estacion = j;
    endif
  endfor

endfunction

# Arma un ranking de estaciones con mas pasos segun el tipo de vehiculo.
function estaciones = rankingEstacionesPorTipoVeh(datos, tipoVeh)
  
  estaciones = zeros(8,1);
  
  for i = 1:rows(datos)
    if(datos(i,7) == tipoVeh) # Si el tipo de vehiculo coincide con el solicitado.
      estaciones(datos(i,5)) += datos(i,9); # Acumula pasos de esa estacion
    endif
  endfor

endfunction

# Genera un balance de egresos/ingresos para cada dia de la semana de una estacion.
function balance = balanceEstacionPorDiaSemana(datos, estacion)
  
  balance = zeros(7,2);
  
  for i = 1:rows(datos)
    if (datos(i,5) == estacion)
      if(datos(i,6) == 1) #Si es ingreso.
        balance(datos(i,4),1) += datos(i,9);
      else #Si es egreso.
        balance(datos(i,4),2) += datos(i,9);
      endif
    endif
  endfor
  
endfunction

#------------------------------------------------------

#Item b.
#figure(1)
#plot(0:23, balancePorHora(datos))
#title("Balances totales por hora.")

#Item c.
#figure(2);
#estacion = mayorCantPasos(datos)
#titulo = strcat("Balance de estación con mayor cantidad de pasos (", int2str(estacion), ")");
#plot(0:23, balanceEstacionPorHora(datos,estacion));
#title(titulo);

#Item d.

#Item e.
#rankingLivianos = rankingEstacionesPorTipoVeh(datos, 1); # 1 = Liviano
#rankingPesados = rankingEstacionesPorTipoVeh(datos, 2); # 2 = Pesado
#figure(4)
#bar(1:8, rankingLivianos)
#title("Ranking de estaciones por pasos de vehiculos livianos.")
#figure(5)
#bar(1:8, rankingPesados)
#title("Ranking de estaciones por pasos de vehiculos pesados.")


#Item f.
#pasosEstacion1 = balanceEstacionPorDiaSemana(datos, 1)
#pasosEstacion2 = balanceEstacionPorDiaSemana(datos, 2)
#figure(6)
#bar(1:7, pasosEstacion2)
#title("Ingresos/egresos por dia en una estacion.")
#pasosEstacion3 = balanceEstacionPorDiaSemana(datos, 3)
#pasosEstacion4 = balanceEstacionPorDiaSemana(datos, 4)
#pasosEstacion5 = balanceEstacionPorDiaSemana(datos, 5)
#pasosEstacion6 = balanceEstacionPorDiaSemana(datos, 6)
#pasosEstacion7 = balanceEstacionPorDiaSemana(datos, 7)
#pasosEstacion8 = balanceEstacionPorDiaSemana(datos, 8)

#Item g.

#Item h.

#Item i.

#------------------------------------------------------

 
 
 
 
 
 
 
 
 
 
 
 
 
