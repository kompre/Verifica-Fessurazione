clearvars
clc
%% cartella di destinazione
path = '../../tettoia_v2/verifiche/';
nomefile = 'verificaFessurazione_Trave_150x35.tex';
%% dimensioni sezione in mm
sezione.b = 1500;
sezione.h = 350;
%% dati della sollecitazione
sollecitazioni = table;
sollecitazioni.Med = [27.56; 25.27];  % momento sollecitante
sollecitazioni.Ned = [0; 0];    % sforzo normale
sollecitazioni.kt = [0.6; 0.4];
sollecitazioni.w_max = [.4 ; .3];
sollecitazioni.Properties.RowNames = {'FRE';'QPR'};
%% dati dell'armatura
armatura = table;
armatura.n = [7;7];   % numero delle barre per riga
armatura.diam = [12;12];  % diametro delle barre per riga
armatura.d = [55;295];   % distanza delle barre dal lembo compresso in mm
armatura.As = armatura.n.*(pi*armatura.diam.^2/4);
armatura.Properties.VariableUnits = {'','mm','mm','mm2'};
%% dati del materiale
cls = derivaCaratteristicheCA(25,30);
steel = derivaCaratteristicheAcciaio();
%% dati della verifica
par = table;
par.alpha_e = [15;15]; %rapporto moduli elastici del materiale
par.Properties.RowNames = {'FRE','QPR'};
combo = {'FRE','QPR'};
[d, i_d] = max(armatura.d);    % altezza utile della sezione
c = sezione.h - d - armatura.diam(i_d)/2 ;  % copriferro nominale, al baricentro delle barre di armatura
%% altezza dei rettangoli
dh = 1;
yi = (0+dh/2):dh:sezione.h; % vettore delle coordinate dei rettangoli
%% verifica combinazione QPR
for i = 1:2
    N = sollecitazioni{combo{i},'Ned'};
    M = sollecitazioni{combo{i},'Med'};
    kt = sollecitazioni{combo{i},'kt'};
    alpha_e = par{combo{i},'alpha_e'};     % rapporto moduli elastici Es/Ecm
    [x.(combo{i}),A,S,J] = asseNeutro(sezione.b, sezione.h, armatura.As, armatura.d, N*1e3, M*1e6, alpha_e);
    h_eff.(combo{i}) = min([2.5*(sezione.h-d),(sezione.h-x.(combo{i}))/3,sezione.h/2]);    % altezza del cls efficace attorno alle armature tese (misurata dal lembo teso di cls)
    i_Aseff = armatura.d > sezione.h - h_eff.(combo{i}); %indice dell'armatura appartenente all'area efficace di cls
    Ac_eff.(combo{i}) = sezione.b * h_eff.(combo{i}); %area di cls teso efficace
    rho_eff.(combo{i}) = sum(armatura.As.*i_Aseff)/Ac_eff.(combo{i}); %rapporto di armatura
    sigma_s.(combo{i}) = alpha_e*M*1e6/J*(d-x.(combo{i})); % tensione delle barre di acciaio (solo per flessione!)
    %% deformazione media della barra di acciaio
    e_ms.(combo{i}) = max([(sigma_s.(combo{i})-kt*cls.f_ctm/rho_eff.(combo{i})*(1+alpha_e*rho_eff.(combo{i})))/steel.Es;0.6*sigma_s.(combo{i})/steel.Es]);
    %% distanza massima tra le fessure
    k1.(combo{i}) = 0.8;
    k2.(combo{i}) = 0.5;
    k3.(combo{i}) = 3.4;
    k4.(combo{i}) = 0.425;
    delta_smax.(combo{i}) = k3.(combo{i})*c + k1.(combo{i})*k2.(combo{i})*k4.(combo{i})*armatura.diam(i_d)/rho_eff.(combo{i});
    %% apertura delle fessure
    w_d.(combo{i}) = e_ms.(combo{i}) * delta_smax.(combo{i});
    ratioW.(combo{i}) = w_d.(combo{i})/sollecitazioni{combo{i},'w_max'};
    
end
%% creazione della tabella latex
tab = fopen(nomefile,'wt');
template = fileread('template.tex');
template = regexprep(template,sprintf('\r'),'');
for i = 1:2
    template = regexprep(template,['_1' combo{i} '_'],sprintf('%.2f',sollecitazioni{combo{i},'Ned'}));
    template = regexprep(template,['_2' combo{i} '_'],sprintf('%.2f',sollecitazioni{combo{i},'Med'}));
    template = regexprep(template,['_3' combo{i} '_'],sprintf('%.1f',sollecitazioni{combo{i},'kt'}));
    template = regexprep(template,['_4' combo{i} '_'],sprintf('%u',par{combo{i},'alpha_e'}));
    template = regexprep(template,['_5' combo{i} '_'],sprintf('%.2f',x.(combo{i})));
    template = regexprep(template,['_6' combo{i} '_'],sprintf('%.2f',sigma_s.(combo{i})));
    template = regexprep(template,['_7' combo{i} '_'],sprintf('%.2f',h_eff.(combo{i})));
    template = regexprep(template,['_8' combo{i} '_'],sprintf('%.2f',Ac_eff.(combo{i})));
    template = regexprep(template,['_9' combo{i} '_'],sprintf('%.3f',rho_eff.(combo{i})));
    template = regexprep(template,['_10' combo{i} '_'],sprintf('%.2e',e_ms.(combo{i})));
    template = regexprep(template,['_11' combo{i} '_'],sprintf('%.1f',k1.(combo{i})));
    template = regexprep(template,['_12' combo{i} '_'],sprintf('%.1f',k2.(combo{i})));
    template = regexprep(template,['_13' combo{i} '_'],sprintf('%.1f',k3.(combo{i})));
    template = regexprep(template,['_14' combo{i} '_'],sprintf('%.3f',k4.(combo{i})));
    template = regexprep(template,['_15' combo{i} '_'],sprintf('%.2f',delta_smax.(combo{i})));
    template = regexprep(template,['_16' combo{i} '_'],sprintf('%.2f',w_d.(combo{i})));
    template = regexprep(template,['_17' combo{i} '_'],sprintf('%.2f',ratioW.(combo{i})));
end
%%
fprintf(tab,'%s',template);
fclose(tab);
copyfile(nomefile,[path nomefile]);
w_d
ratioW
disp(['"' nomefile '" è stato copiato in "' path '"'])