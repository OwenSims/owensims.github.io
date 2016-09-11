function mmtype(D)

% This is an elaboration of the BROKERAGE function.
% Nodes are identified as either strong middlemen, weak middlemen, or non-middlemen
% as defined in Sims and Gilles (2014).

% Requires an adjacency matrix. We denote the matrix as D.


n = size(D,1);
Z = zeros(n);
OUT = cumsum(D,2);
D1 = Z;

for i = 1:n
	D1 = D1 + logical(D^i);
	D1 = logical(D1);
end

D1(logical(eye(size(D1)))) = 0;

B = sum(transpose(D1));
B_all = sum(B);

DT = transpose(D);
DT1 = Z;

for i = 1:n
	DT1 = DT1 + logical(DT^i);
	DT1 = logical(DT1);
end

DT1(logical(eye(size(DT1)))) = 0;

C = sum(transpose(DT1));
C_all = sum(C);

for i = 1:n
	P(i,1) = B(i) - OUT(i,n);
end

P = max(sum(P),1);

for i = 1:n
	G = D;
	G(:,i)=0;
	G(i,:)=0;
	GG = zeros(n);
		for j = 1:n
			GG = GG + logical(G^j);
			GG = logical(GG);
		end
	GG(logical(eye(size(GG)))) = 0;
	B_2 = sum(transpose(GG));
	B_2_all = sum(B_2);
	tau(i,1) = B_all - B_2_all - (B(i) + C(i));
end

v = tau/P;


% Are the nodes weak middlemen or strong middlemen?

U = D + transpose(D);
U = logical(U);
U1 = Z;

for i=1:n
	U1 = U1 + logical(U^i);
	U1 = logical(U1);
end

U1(logical(eye(size(U1)))) = 0;
F = sum(transpose(U1));
F_all = sum(F);

for i = 1:n
	G = U;
	G(:,i)=0;
	G(i,:)=0;
	GG = zeros(n);
		for j=1:n
			GG = GG + logical(G^j);
			GG = logical(GG);
		end
	GG(logical(eye(size(GG)))) = 0;
	F_2 = sum(transpose(GG));
	F_2_all = sum(F_2);
	NPU(i,1) = F_all - F_2_all - (F(i) + F(i));
end

for i = 1:n
	if tau(i) == 0 && NPU(i) == 0;
		fprintf('Node %0.0f is a non-middleman\n',i);
	elseif tau(i) > 0 && NPU(i) == 0;
		fprintf('Node %0.0f is a weak middleman\n',i);
	elseif tau(i) > 0 && NPU(i) > 0;
		fprintf('Node %0.0f is a strong middleman\n',i);
	end
end

