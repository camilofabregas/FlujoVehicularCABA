# Trabajo Práctico 1 - Grupo 17 - Modelación Númerica - 1er cuatrimestre 2021

#Item a.
datos = load('FlujoVehicular2019.dat'); # Lee el conjunto de datos del archivo.

#------------------------------------------------------

#FUNCIONES

# Recibe una tabla de datos y devuelve una matriz con ingresos y egresos
# totales por hora.
function pasPorHora = pasosPorHora(tabla)
  
  pasPorHora = zeros(24,2);
  
  for i = 1:rows(tabla)
    pasPorHora = acumularPasosPorHora(tabla(i,:),pasPorHora);
  endfor
  
endfunction

# Recibe una tabla de datos y calcula el balance para cada hora en una
# estación específica.
function balPorHora = balanceEstacionPorHora(tabla,estacion)
  
  pasPorHora = zeros(24,2);
  balPorHora = zeros(24,1);
  
  for i = 1:rows(tabla)
    if(tabla(i,5) == estacion)
      pasPorHora = acumularPasosPorHora(tabla(i,:),pasPorHora);
    endif
  endfor
  
  balPorHora = pasPorHora(:,1)-pasPorHora(:,2);
  
endfunction

# Acumula pasos por hora en una matriz y la devuelve.
function pasosPorHora = acumularPasosPorHora(fila,pasPorHora)
  
  pasosPorHora = pasPorHora;
  
  if(fila(6) == 1) #Si es ingreso.
    pasosPorHora(fila(3)+1, 1) += fila(9); #Sumo cantidad de ingresos a la hora.
  else #Si es egreso.
    pasosPorHora(fila(3)+1, 2) += fila(9); #Sumo cantidad de egresos a la hora.
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
figure(1);
plot(0:23, pasosPorHora(datos)(:,1), 'o-b');
title("Ingresos totales por hora.");
xticks(0:23);
xlabel("Horas");

figure(2);
plot(0:23, pasosPorHora(datos)(:,2), 'o-r');
title("Egresos totales por hora.");
xticks(0:23);
xlabel("Horas");

figure(3);
plot(0:23, pasosPorHora(datos)(:,1) - pasosPorHora(datos)(:,2), 'o-k');
title("Balances totales por hora.");
xticks(0:23);
xlabel("Horas");

#Item c.
figure(4);
estacion = mayorCantPasos(datos);
titulo = strcat("Balance de estación con mayor cantidad de pasos (", int2str(estacion), ")");
plot(0:23, balanceEstacionPorHora(datos,estacion), 'o-k');
title(titulo);
xticks(0:23);
xlabel("Horas");

#Item d.

#Item e.
rankingLivianos = rankingEstacionesPorTipoVeh(datos, 1); # 1 = Liviano
rankingPesados = rankingEstacionesPorTipoVeh(datos, 2); # 2 = Pesado
figure(5)
bar(1:8, rankingLivianos)
title("Ranking de estaciones por pasos de vehiculos livianos.")
figure(6)
bar(1:8, rankingPesados)
title("Ranking de estaciones por pasos de vehiculos pesados.")


#Item f.
pasosEstacion1 = balanceEstacionPorDiaSemana(datos, 1)
pasosEstacion2 = balanceEstacionPorDiaSemana(datos, 2)
figure(7)
bar(1:7, pasosEstacion2)
title("Ingresos/egresos por dia en una estacion.")
pasosEstacion3 = balanceEstacionPorDiaSemana(datos, 3)
pasosEstacion4 = balanceEstacionPorDiaSemana(datos, 4)
pasosEstacion5 = balanceEstacionPorDiaSemana(datos, 5)
pasosEstacion6 = balanceEstacionPorDiaSemana(datos, 6)
pasosEstacion7 = balanceEstacionPorDiaSemana(datos, 7)
pasosEstacion8 = balanceEstacionPorDiaSemana(datos, 8)

#Item g.

#Item h.

#Item i.

#------------------------------------------------------

 
 
 
 
 
 
 
 
 
 
 
 
 
