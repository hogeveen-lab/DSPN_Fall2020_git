% Jeremy Hogeveen;Hodgkin-Huxley MATLAB implementation;
% Reference: http://lcn.epfl.ch/~gerstner/SPNM/node14.html;

%%%%%%%%%%
% This was the first fancy thing I scripted in Fall, 2011.
% No comments, disorganized, inconsistent / noisy naming schemes... 
% Way tougher to parse for 2020 me than it should be. 
% Clean code saves time.
%%%%%%%%%%

function varargout = H_H_Jeremy_Hogeveen_v1(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @H_H_Jeremy_Hogeveen_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @H_H_Jeremy_Hogeveen_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function H_H_Jeremy_Hogeveen_v1_OpeningFcn(hObject, ~, handles, varargin);
handles.output = hObject;
guidata(hObject, handles);

function varargout = H_H_Jeremy_Hogeveen_v1_OutputFcn(~, ~, handles); 

varargout{1} = handles.output;


% pushbutton for Single Pulse.;
function pushbutton1_Callback(hObject, ~, handles);
axes (handles.Voltage);
set(gcbo,'Backgroundcolor','w');
% Constants and initial conditions;

dT=0.01;
Ena=115;
Ek=-12;
Ecl=10.6;
Gna=120;
Gk=36;
Gcl=0.3;
V(1)=0;
Vsteady=0;
Vstim=10;
Vonset=500;
Voffset=Vonset+100;
Istim(1)=0;

am(1) = (2.5-0.1*V(1))/(exp(2.5-0.1*V(1))-1);
bm(1) = 4*exp((-1)*V(1)/18);
an(1) = (0.1-0.01*V(1))/(exp(1-(0.1*V(1)))-1);
bn(1) = 0.125/exp((-1)*V(1)/80);
ah(1) = 0.07*exp((-1)*V(1)/20);
bh(1) = 1/(exp(3-(0.1)*V(1))+1);

m(1) = am(1) / (am(1)+bm(1));
n(1) = an(1) / (an(1)+bn(1));
h(1) = ah(1) / (ah(1)+bh(1));
dm(1) = am(1)*(1-m(1))-(bm(1)*m(1));
dn(1) = an(1)*(1-n(1))-(bn(1)*n(1));
dh(1) = ah(1)*(1-h(1))-(bh(1)*h(1));


for i=2:1:4000;
    
    % Three current components;
    Ina(i) = Gna*(m(i-1)^3)*h(i-1)*(V(i-1)-Ena);
    Ik(i)  = Gk *(n(i-1)^4)*(V(i-1)-Ek);
    Icl(i) = Gcl*(V(i-1)-Ecl);
    It(i)  = Ina(i-1) + Ik(i-1) + Icl(i-1);
    
    % Istim parameters, Single Pulse Current;
     if  i < Vonset;
        Istim(i) = Vsteady;
     elseif i < Voffset;
        Istim(i) = Vstim;
     else
        Istim(i) = Vsteady;
     end
     
    % Voltage and dVdT;
     V(i) = V(i-1) + dT * (Istim(i-1)-It(i-1));
    
    % m, n, and h
    am(i) = (2.5-0.1*V(i))/(exp(2.5-0.1*V(i))-1);
    bm(i) = 4*exp((-1)*V(i)/18);
    an(i) = (0.1-0.01*V(i))/(exp(1-(0.1*V(i)))-1);
    bn(i) = 0.125/exp((-1)*V(i)/80);
    ah(i) = 0.07*exp((-1)*V(i)/20);
    bh(i) = 1/(exp(3-(0.1)*V(i))+1);
    m(i) = m(i-1) + dT * dm(i-1);
    n(i) = n(i-1) + dT * dn(i-1);
    h(i) = h(i-1) + dT * dh(i-1);
    dm(i) = am(i)*(1-m(i))-(bm(i)*m(i));
    dn(i) = an(i)*(1-n(i))-(bn(i)*n(i));
    dh(i) = ah(i)*(1-h(i))-(bh(i)*h(i)); 
    
end
time = 0 : dT : 3999*dT;

% Voltage Plot;
plot (time,V,time,Istim);
xlabel('time');
ylabel('V');
guidata(hObject,handles);

% m, n, h Plot;
axes (handles.axes1);
plot (time,m,time,n,time,h);
xlabel('time');
ylabel('m,n,h');
guidata(hObject,handles);

% Pushbutton for Constant Current.
function pushbutton6_Callback(hObject, ~, handles);
axes (handles.Voltage);
set(gcbo,'Backgroundcolor','w');
dT=0.01;
Ena=115;
Ek=-12;
Ecl=10.6;
Gna=120;
Gk=36;
Gcl=0.3;
V(1)=0;
Vsteady=0;
Vstim=10;
Vonset=500;
Voffset=Vonset+100;
Istim(1)=0;

am(1) = (2.5-0.1*V(1))/(exp(2.5-0.1*V(1))-1);
bm(1) = 4*exp((-1)*V(1)/18);
an(1) = (0.1-0.01*V(1))/(exp(1-(0.1*V(1)))-1);
bn(1) = 0.125/exp((-1)*V(1)/80);
ah(1) = 0.07*exp((-1)*V(1)/20);
bh(1) = 1/(exp(3-(0.1)*V(1))+1);

m(1) = am(1) / (am(1)+bm(1));
n(1) = an(1) / (an(1)+bn(1));
h(1) = ah(1) / (ah(1)+bh(1));
dm(1) = am(1)*(1-m(1))-(bm(1)*m(1));
dn(1) = an(1)*(1-n(1))-(bn(1)*n(1));
dh(1) = ah(1)*(1-h(1))-(bh(1)*h(1));

for i=2:1:4000;
    
    Ina(i) = Gna*(m(i-1)^3)*h(i-1)*(V(i-1)-Ena);
    Ik(i)  = Gk *(n(i-1)^4)*(V(i-1)-Ek);
    Icl(i) = Gcl*(V(i-1)-Ecl);
    It(i)  = Ina(i-1) + Ik(i-1) + Icl(i-1);
    
    % Istim parameters, Constant Current;
     if  i < Vonset;
        Istim(i) = Vsteady;
     elseif Vonset <= i;
        Istim(i) = Vstim;
     else
        Istim(i) = Vsteady;
     end
     
     V(i) = V(i-1) + dT * (Istim(i-1)-It(i-1));
    
    am(i) = (2.5-0.1*V(i))/(exp(2.5-0.1*V(i))-1);
    bm(i) = 4*exp((-1)*V(i)/18);
    an(i) = (0.1-0.01*V(i))/(exp(1-(0.1*V(i)))-1);
    bn(i) = 0.125/exp((-1)*V(i)/80);
    ah(i) = 0.07*exp((-1)*V(i)/20);
    bh(i) = 1/(exp(3-(0.1)*V(i))+1);
    m(i) = m(i-1) + dT * dm(i-1);
    n(i) = n(i-1) + dT * dn(i-1);
    h(i) = h(i-1) + dT * dh(i-1);
    dm(i) = am(i)*(1-m(i))-(bm(i)*m(i));
    dn(i) = an(i)*(1-n(i))-(bn(i)*n(i));
    dh(i) = ah(i)*(1-h(i))-(bh(i)*h(i)); 
    
end
time = 0 : dT : 3999*dT;

% Voltage Plot;
plot (time,V,time,Istim);
xlabel('time');
ylabel('V');
guidata(hObject,handles);

% m, n, h Plot;
axes (handles.axes1);
plot (time,m,time,n,time,h);
xlabel('time');
ylabel('m,n,h');
guidata(hObject,handles);

% pushbutton for Clear Plots.
function pushbutton4_Callback(hObject, ~, handles);
cla(handles.Voltage,'reset');
cla(handles.axes1,'reset');
guidata(hObject, handles);
