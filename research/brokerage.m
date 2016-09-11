function [tau, v] = brokerage(D)

% BROKERAGE Measures the number of relationships 
% that certain nodes monopolise or broker, and
% evaluates whether nodes are strong, weak, or
% non-middlemen.

% If:
% [tau, v] = brokerage(D)
% Then: Result provides a vector of raw brokerage (tau) for all nodes, and a vector of normalised brokerage (v) for all nodes.

% If:
% brokerage(D)
% Then: Result provides a vector of raw brokerage (tau) for all nodes only.

% Note that the initial adjacency matrix is denoted by D.


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
