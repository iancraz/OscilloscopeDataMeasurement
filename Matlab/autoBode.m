function[ F, Mag, Phase ] = autoBode(Vin_set, tEst, nPoints, type, idOsc, idGen)

    

    [ osc, gen ] = connection(idOsc, idGen);
    delay = 0.00001;
    startFreq = 6.1e3;
    statMeasures = 3;
    capturedPoints = 0;
    type = lower(type);
    margin = 0.5;
    %maxFreq = str2double(query(gen, 'FREQ? MAX'));
    maxFreq = 800e3;
    if(strcmp(type, 'lin') == 1)
        F = startFreq:(maxFreq-startFreq)/nPoints:maxFreq;
    elseif(strcmp(type, 'log') == 1)
        F = logspace(log10(startFreq),log10(maxFreq), nPoints);
    end
    
    % Setear el tipo de señal del generador: Vin y Sin:
    fprintf(gen, 'FUNC SIN');
    pause(delay);
    fprintf(gen, char(strcat({'VOLT '}, num2str(Vin_set), ' VPP')));
    pause(delay);
    fprintf(gen, char(strcat({'FREQ '}, num2str(F(1)))));
    pause(delay);
    % Acomodo las escalas del osc para medicion optima
    % obtengo tension de alimentacion

    
    Vgen = str2double(query(gen, 'VOLT?'));
    pause(delay);
    Fgen = str2double(query(gen, 'FREQ?'));
    pause(delay);
    vRange = Vgen + Vgen * margin;
   
    fprintf(osc, char(strcat({':CHAN1:RANG '}, num2str(vRange))));
    pause(delay);
    fprintf(osc, char(strcat({':CHAN2:RANG '}, num2str(vRange))));
    pause(delay);
    
    Trange = 2/Fgen;
    fprintf(osc, char(strcat({':TIM:RANG '}, num2str(Trange))));
    pause(delay);
    pause(0.2);
    while(capturedPoints < nPoints)
        % Para el primer dato escalo el osc respecto de la entrada
        % Seteo la frecuencia de salida del generador
        fprintf(gen, char(strcat({'FREQ '}, num2str(F(capturedPoints + 1)))));
        pause(delay);
        % Seteo el trigger:
        fprintf(osc, ':TRIG:HFR 0');
        pause(delay);
        fprintf(osc, 'TRIG:LIFIF');
        pause(delay);
        % Acomodo las escalas del osc para medicion optima
        % obtengo tension de alimentacion
        
        fprintf(osc, ':MEAS:VPP CHAN1');
        pause(delay);
        VrangeOscIn = str2double(query(osc, ':MEAS:VPP?'));
        pause(delay);
        fprintf(osc, ':MEAS:VPP CHAN2');
        pause(delay);
        VrangeOscOut = str2double(query(osc, ':MEAS:VPP?'));
        pause(delay);

        
        vRangeIn = VrangeOscIn + VrangeOscIn * margin;
        vRangeOut = VrangeOscOut + VrangeOscOut * margin; 
        fprintf(osc, char(strcat({':CHAN1:RANG '}, num2str(vRangeIn))));
        pause(delay);
        fprintf(osc, char(strcat({':CHAN2:RANG '}, num2str(vRangeOut))));
        pause(delay);
        
        fprintf(osc, ':MEAS:FREQ CHAN1');
        pause(delay);
        FOscIn = str2double(query(osc, ':MEAS:FREQ?'));
        pause(delay);
        fprintf(osc, ':MEAS:FREQ CHAN2');
        pause(delay);
        FOscOut = str2double(query(osc, ':MEAS:FREQ?'));
        pause(delay);
        
        if(FOscIn > FOscOut)
            OscTRange = 1/FOscOut;
        elseif(FOscIn <= FOscOut)
            OscTRange = 1/FOscIn;
        end
        
        OscTRange = 2*OscTRange;
        fprintf(osc, char(strcat({':TIM:RANG '}, num2str(OscTRange))));
        pause(delay);
        % Tiempo de restablecimiento
        pause(tEst);
        % Adquicision de datos
        for k = 1:statMeasures
            fprintf(osc, ':MEAS:VPP CHAN1');
            pause(delay);
            VinStat(k) = str2double(query(osc, ':MEAS:VPP?'));
            pause(delay);
            fprintf(osc, 'MEAS:VPP CHAN2');
            pause(delay);
            VoutStat(k) = str2double(query(osc, ':MEAS:VPP?'));
            pause(delay);
            
            % Probar en interfaz grafica!!
            fprintf(osc, ':MEAS:PHAS CHAN1,CHAN2');
            pause(delay);
            PhaseStat(k) = str2double(query(osc, 'MEAS:PHAS?'));
            pause(delay);
            if(PhaseStat(k) > 180)
                PhaseStat(k) = PhaseStat(k) - 180;
            elseif(PhaseStat(k) < -180)
                PhaseStat(k) = PhaseStat(k) + 180;
            end
            
        end
        Vin(capturedPoints + 1) = mean(VinStat);
        Vout(capturedPoints + 1) = mean(VoutStat);
        Phase(capturedPoints + 1) = mean(PhaseStat);
        
        capturedPoints = capturedPoints + 1;
        
    end
    Mag = 20*log10(Vout./Vin);
    Phase = Phase.*(-1);
end