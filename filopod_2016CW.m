%This is last version of the code 02/08/2016
%
function [m, vstore,Length] = filopod_2016CW(number, trange, length, koff, kon, vp,m0,etai,zetai,betai,sig0i, tk, Di)

m0= m0;

TK = tk;
%zeta = 1000
zeta = zetai;
%eta = etai;
eta = etai;
%sig0 = 10.0;
sig0= sig0i;
N = number;
k_off = koff;
%k_on = 0.1;
k_on = kon;
Vp = vp;
%D = 0.1;
%D=0.07
D=Di;
c = 0.05;
Totaltime = trange;
Length(1) = length;
Skip = 200;
dt = 0.0001;
NSteps = ceil(Totaltime./dt./Skip) + 1;
m = zeros(10.*N, NSteps+1);
dLdt = 0;
alpha = 1;
v=zeros(N);
total_length = zeros((NSteps)*10,1);
x = linspace(0, 15*Length, 10*N);
Dx = x(2)-x(1)
size(Dx)
%beta = 5*eta/Dx/2;
beta = betai*eta/Dx/2;
t(1) = 0;
[ku,index] = min(abs(x-Length));
%index = ku(2);
epsl = Length-x(index-1)-Dx;
N  = index;
%F = zeros(NSteps-1,1);
%v_array =[];
vstore= cell(NSteps,1);

for n=1:NSteps-1;
    mMid = m(:,n);
    Length(n+1) = Length(n);
    t(n+1) = t(n);
    for l = 1:Skip  
%         if n >= ceil((NSteps-1)*0.75)
%             M = zeros(N,N);
%            Vp=0.1;
%        end;
       M = sparse((2:N-2),(2:N-2), zeta+2.*eta./Dx^2, N, N);
       %upper diagonal
       M = M+sparse((2:N-2),(3:N-1), -eta./Dx.^2, N, N);
       %lower diagonal
       M = M+sparse(1,1, beta-3.*eta./2./Dx, N, N);
       M = M+sparse(1,3, -eta./2./Dx, N, N);
       M = M+sparse(1,2,2.*eta./Dx,N,N);
       M = M+sparse((2:N-2),(1:N-3), -eta./Dx.^2, N,N);
       M = M+sparse(N-1,N-1,zeta+2.*eta./(Dx.*(Dx+epsl)),N,N);
       M = M+sparse(N-1,N,-2*eta/((2.*Dx+epsl).*(Dx+epsl)),N,N);
       M = M+sparse(N-1,N-2,-2*eta/((2.*Dx+epsl).*Dx),N,N);
       M = M+sparse(N,N-2, eta.*(Dx+epsl)./(Dx.*(2.*Dx+epsl)),N,N);
       M = M+sparse(N,N-1, -(2.*Dx+epsl).*eta./(Dx.*(Dx+epsl)),N,N);
       M = M+sparse(N,N, (3.*Dx+2.*epsl).*eta./((Dx+epsl).*(2*Dx+epsl)),N,N);
       %end;
        %update B matrix
        %recompute the velocity matrix component
        B = zeros(N,1);
        B(1) = -sig0.*mMid(1);
        B(2:N-2) = sig0.*(mMid(3:N-1)-mMid(1:N-3))./2./Dx;
        B(N-1) = sig0./(Dx.*(Dx+epsl).*(2.*Dx+epsl)).*(Dx.^2.*mMid(N)-(Dx+epsl).^2*mMid(N-2)+(2.*Dx+epsl).*epsl.*m(N-1));
        B(N) = -TK;
        v = M\B;
        %%%%%MOVING BOUNDARY O%%%%%%
        %Diagonal
        O = sparse((2:N-2),(2:N-2), k_off.*dt./2+dt.*(v(3:N-1)-v(1:N-3))./8./Dx+D.*dt./Dx.^2, N, N);
        O = O+sparse((N-1),(N-1),k_off.*dt./2+dt.*(v(N)-v(N-2))./8./(Dx+epsl./2)+D.*dt./(Dx.*(Dx+epsl)), N, N);
        %Upper Diagonal
        O = O+sparse((2:N-2),(3:N-1), dt*((v(3:N-1)+v(2:N-2)))./8./Dx, N, N);
        O = O+sparse((2:N-2),(3:N-1), -D.*dt./2./Dx.^2, N, N);
        %Lower Diagonal
        O = O+sparse((2:N-2),(1:N-3), -dt*(v(2:N-2)+v(1:N-3))./8./Dx, N, N);
        O = O+sparse((2:N-2),(1:N-3), -D.*dt./2./Dx.^2, N, N);
        O = O+sparse((N-1),(N-2),-dt.*(v(N-1)+v(N-2))./8./Dx-D.*dt./(Dx.*(2.*Dx+epsl)),N,N);
        %Boundary
        O = O+sparse(1, 1,-3.*D./2./Dx-v(1), N, N);
        O = O+sparse(1,2,2.*D./Dx,N,N);
        O = O+sparse(1,3,-D./2./Dx,N,N);
        M1 = speye(N,N)-O;
        M2 = speye(N,N)+O;
        if v(1)>=0
            alph = 0;
        else
            alph = alpha;
        end;
        
        M2(1,:) = 0;
        
        M2 = M2+sparse(1, 1, (3*D./2./Dx+(1-alph)*v(1)),N,N);
        M2 = M2+sparse(1,2,-2*D./Dx,N,N);
        M2 = M2+sparse(1,3,D./2./Dx,N,N);
        
        %Plug into the boundary conditions
        C = M1*mMid(1:N)+m0*k_on*dt;
        %Neuman boundary condition at the base.
        C(1) = 0;
        %Dirichlet boundary condition at the tip
        C(N) = 0;
        mMid(1:N) = M2\C;
        %update time step
        t(n+1) = t(n+1) + dt;
        oldN = N;
        %compute the length change
%         display(size(Length));
%         display(size(v));
        Length(n+1) = Length(n+1)+dt.*(Vp+v(N));
        vstore{n,1} = v;
        %if Length(n+1)==0
         %   return;
        %end;
        epsl = epsl+dt.*(Vp+v(N));
        m(:,n+1) = mMid;
        if epsl<=-Dx/2
            epsl = epsl+Dx;
            N=N-1;
            m(N,n+1) = 0;
        elseif epsl>Dx/2
            epsl = epsl-Dx;
            N=N+1;
            m(N-1,n+1) = (1-Dx./(2.*Dx+epsl)).*m(N-2,n+1);
            m(N,n+1) = 0;
        end;  
        mMid = m(:,n+1);
        total_length(n*l+l) = length-Length(n+1);
    end;
    
%     clf;
%      f = figure;
    if (numel(mMid)<oldN) || (numel(x)<oldN);
        display('N too large, exiting loop');
    else
%         subplot(1,2,1);
%         [haxes,hline1,hline2]=plotyy(x(1:oldN),m(1:oldN,n+1),x(1:oldN),v(1:oldN));
%         axis(haxes(1),[0 20 0 405]);axis(haxes(2),[0 20 -4 4]);
%         set(hline1, 'linewidth',4);
%         set(hline2, 'linewidth',4);
%         xlabel('Length, \mum', 'FontSize',20);
%         ylabel('Conc. \muM, Retrograde flow, \mum/min', 'FontSize',20);
%         subplot(1,2,2)
%         plot(t,Length);
%         axis([0 trange 0 50]);
%         ylabel('Length, \mum','FontSize',20);
%         xlabel('Time, a.u.', 'FontSize',20);
%         set(gca, 'FontSize',20);
%         drawnow
        
    end;
    %title( sprintf( '%s: %d, %s: %d, %s: %d,  %s: %d, %s: %d', '\eta', eta, '\sigma_0', sig0, 'k_{on}', kon, 'k_{off}', koff, 'vp', vp), 'FontSize',20);
   %close(ancestor(f, 'figure'));
   close all;
end

% eta = 5 pN s
% zeta = 5 pN s/um2
% sigma0 = 1.3
% m0 = 5 pN/um
% beta = 1250 pN s/um
% koff = 0.029 s-1
% kon = 0.027 s-1
% D = 0.04 m2 /s
% vp = 0.08 um/s
