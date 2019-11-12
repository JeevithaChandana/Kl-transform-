clc;
clear all;
%%
[x,fs]=audioread('sp02_restaurant_sn10.wav');
samples=[1,(length(x)-(ceil(2*fs)))];
%%
[x1,fs1]=audioread('sp02_restaurant_sn10.wav',samples);
N=length(x1);
%%
m=mean(x1);
c=(((x1-m)*(x1-m)'));
%%
[U,d]=eig(c);

%%
[l,h]=sort(diag(d),'descend');

%%
for r=1:3
    P(:,r)=U(:,h(r,1));
end
%%
J=ctranspose(P);
%%
P1=(P*J);
P2=P1*(x1-m);
%%
E=wthresh(P2,'h',0.04);

 count=0;
for i=1:length(x1)
    if(E(i)==0)
        count=count+1;
    end
end
disp(count);
j=length(x1)-count;
%%
B=randn(N,N);
y1=B*E;
R=OMP(y1,B,j);

%%
I=P1'*(R)+m;
u=audioread('sp02.wav',samples);
[E,T]=Overall_snr_Seg_snr(u,I,fs);
O=snr(u,I);
plot(x1);
hold on;
plot(I);
