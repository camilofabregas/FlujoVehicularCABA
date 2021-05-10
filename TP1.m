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


function movTotalPorHora = acumularMovilidadPorHora(datos)
    movTotalPorHora = zeros(24,1);
    
    for i = 1:rows(datos)
      movTotalPorHora(datos(i,3)+1) += datos(i,9);
    endfor
   
    disp('Movilidad por hora');
    disp(movTotalPorHora);
    disp('Fin movilidad por hora');
 
 endfunction
 

#Son 22 franjas de 3 horas, la primera franja es desde las 0 hasta las 2, la segunda desde la 1 hasta las 3 y asi...
function movilidadPorFranja = acumularMovilidadPorFranja(movilidadPorHora)
   
   movilidadPorFranja = zeros(22,2);
   for i = 1: rows(movilidadPorFranja)
     movilidadPorFranja(i,1) = i;
     movilidadPorFranja(i,2) = movilidadPorHora(i) + movilidadPorHora(i+1) + movilidadPorHora(i+2);
   endfor
   
   disp('Movilidad por franja');
   disp(movilidadPorFranja);
   disp('Fin movilidad por franja');
   
endfunction
 
function franjasConMayorMovilidad = obtenerFranjasConMayorMovilidad(movilidadPorFranja)
   franjasConMayorMovilidad = zeros(2,2);
   
   for i = 1:rows(movilidadPorFranja)
     if (movilidadPorFranja(i,2) > franjasConMayorMovilidad(1,2))
       franjasConMayorMovilidad(1,1) = movilidadPorFranja(i,1);
       franjasConMayorMovilidad(1,2) = movilidadPorFranja(i,2);
     endif
   endfor
   
   for i = 1:rows(movilidadPorFranja)
     if (movilidadPorFranja(i,2) > franjasConMayorMovilidad(2,2)) && (movilidadPorFranja(i,1) > (franjasConMayorMovilidad(1,1) + 3)) || (movilidadPorFranja(i,1) < (franjasConMayorMovilidad(1,1) - 3))
       franjasConMayorMovilidad(2,1) = movilidadPorFranja(i,1);
       franjasConMayorMovilidad(2,2) = movilidadPorFranja(i,2);
     endif
   endfor
   
   disp('Franjas con mayor movilidad');
   disp(franjasConMayorMovilidad);
   
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

# Genera un balance de egresos/ingresos para cada mes de una estacion.
function balance = balanceEstacionPorMes(datos, estacion)
  
  balance = zeros(12,2);
  
  for i = 1:rows(datos)
    if (datos(i,5) == estacion)
      if(datos(i,6) == 1) #Si es ingreso.
        balance(datos(i,1),1) += datos(i,9);
      else #Si es egreso.
        balance(datos(i,1),2) += datos(i,9);
      endif
    endif
  endfor
  
endfunction

# Recibe una tabla de datos y devuelve una matriz 24x4 con los pasos totales
# por hora (filas) correspondientes a cada forma de pago (columnas).
function pasSinCobrar = pasosSinCobrarPorHora (tabla)
  
  pasSinCobrar = zeros(24,4);
  
  for i = 1:rows(tabla)
    pasSinCobrar = acumularPasosSinCobrarPorHora(tabla(i,:),pasSinCobrar);
  endfor
  
  
endfunction

# Acumula pasos por hora sin cobrabilidad en una matriz 24x4 y la devuelve.
function pasosSinCobrar = acumularPasosSinCobrarPorHora(fila,pasSinCobrar)
  
  pasosSinCobrar = pasSinCobrar;
  
  switch(fila(8))
    case 102
      pasosSinCobrar(fila(3)+1, 1) += fila(9);
    case 103
      pasosSinCobrar(fila(3)+1, 2) += fila(9);
    case 104
      pasosSinCobrar(fila(3)+1, 3) += fila(9);
    case 105
      pasosSinCobrar(fila(3)+1, 4) += fila(9);
  endswitch
  
endfunction

#------------------------------------------------------

#Item b.
figure(1);
plot(0:23, pasosPorHora(datos)(:,1), 'o-b');
title("Ingresos totales por hora.");
xticks(0:23);
xlabel("Horas");
ylabel("Ingresos");

figure(2);
plot(0:23, pasosPorHora(datos)(:,2), 'o-r');
title("Egresos totales por hora.");
xticks(0:23);
xlabel("Horas");
ylabel("Egresos");

figure(3);
plot(0:23, pasosPorHora(datos)(:,1) - pasosPorHora(datos)(:,2), 'o-k');
title("Balances totales por hora.");
xticks(0:23);
xlabel("Horas");
ylabel("Balance");

#Item c.
figure(4);
estacion = mayorCantPasos(datos);
titulo = strcat("Balance de estación con mayor cantidad de pasos (", int2str(estacion), ")");
plot(0:23, balanceEstacionPorHora(datos,estacion), 'o-k');
title(titulo);
xticks(0:23);
xlabel("Horas");
ylabel("Balance");

#Item d.
figure(5)
plot(0:23, acumularMovilidadPorHora(datos),'--o');
title('Movilidad total por hora');
xticks(0:23);
xlabel("Horas");
ylabel("Movilidad");
obtenerFranjasConMayorMovilidad(acumularMovilidadPorFranja(acumularMovilidadPorHora(datos)));

#Item e.
rankingLivianos = rankingEstacionesPorTipoVeh(datos, 1); # 1 = Liviano
rankingPesados = rankingEstacionesPorTipoVeh(datos, 2); # 2 = Pesado
figure(6)
bar(1:8, rankingLivianos)
title("Ranking de estaciones por pasos de vehiculos livianos.")
figure(7)
bar(1:8, rankingPesados)
title("Ranking de estaciones por pasos de vehiculos pesados.")

#Item f.
#Hacer graficos para las 8 estaciones. Dejo 1 a modo de ejemplo.
pasosEstacion = balanceEstacionPorDiaSemana(datos, 2); # Estacion 2
figure(8)
bar(1:7, pasosEstacion)
title("Ingresos/egresos por dia en una estacion.")

#Item g.
#Hacer graficos para las 8 estaciones. Dejo 1 a modo de ejemplo.
pasosEstacion = balanceEstacionPorMes(datos, 2); # Estacion 2
figure(8)
bar(1:12, pasosEstacion)
title("Ingresos/egresos por mes en una estacion.")

#Item h.
pasosSinCobrar = pasosSinCobrarPorHora(datos);
pasosSCTotales = pasosSinCobrar(:,1) + pasosSinCobrar(:,2) + pasosSinCobrar(:,3) + pasosSinCobrar(:,4);
figure(9)
hold on
plot(0:23, pasosSinCobrar(:,1), 'o-m;Exento;');
plot(0:23, pasosSinCobrar(:,2), 'x-b;Infraccion;');
plot(0:23, pasosSinCobrar(:,3), 's-r;No cobrado;');
plot(0:23, pasosSinCobrar(:,4), 'd-g;T. Discapacidad;');
xticks(0:23);
xlabel("Horas");
ylabel("Pasos");

figure(10)
plot(0:23, pasosSCTotales, 'v-k;Total sin cobrabilidad;');
xticks(0:23);
xlabel("Horas");
ylabel("Pasos");

#Item i.

#------------------------------------------------------

 
 
 
 
 
 
 
 
 
 
 
 
 
