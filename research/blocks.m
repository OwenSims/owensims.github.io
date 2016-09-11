function blocks(D)

% BLOCKS

% INPUT : Adjacency matrix D.
% OUTPUT : (1) Prints a list of all node sets that are blocks and middlemen, and (2) Provides a measure of each blocks/middlemans brokerage score (v) and egalitarian power score (phi).


n = length(D);

Z = zeros(n);

% Provide the 'connectivity matrix' (DT) from adjacency matirx D: who can contact who by a walk.

DT = Z;

	for i = 1:n
		DT = DT + logical(D^i);
		DT = logical(DT);
	end

DT(logical(eye(size(DT)))) = 0;

% Collect all combination of nodes (the size of a power set is 2^n). Analyse each set (S).

	for tag = 1:2^n-1
    	H = D;
	    D1 = DT;
	    S = zeros(1,n);

	    for i = 1:n
		    if	mod(floor(tag/2^(i-1)), 2) == 1
				H(:,i) = 0;
				H(i,:) = 0;
				S(1,i) = i;
			end
		end

		S(S==0) = [];
		S = sort(S);
		q = length(S);

		% for j = 1:length(S)
			% eval(['i' num2str(j) ' = S(1,j)']);
		% end

		H;						% Matrix with combinations of nodes removed
		HH = zeros(n);

		for m = 1:n
			HH = HH + logical(H^m);
   			HH = logical(HH);
   		end

		HH(logical(eye(size(HH)))) = 0;
		F = sum(transpose(HH));
		t = sum(F); 			% The new connectivity of the matrix minus the node set S

		for k = 1:length(S)
			D1(S(1,k),:) = 0;
			D1(:,S(1,k)) = 0;
		end

		K = sum(transpose(D1));
		r = sum(K);  			% The adjusted connectivity of the network with respect to S
		v = r - t;				% We note that r >= t
		phi = v/q; 				% The egalitarian distibution of power
			
		if v > 0 && q > 1;
			disp(strrep(['Block: (' sprintf('%d,', S) ')'], ',)', ')'));
			fprintf('Brokerage: %0.0f.\n--------------------\n', v);
			%fprintf('Phi: %d.\n--------------------\n', phi);
		elseif v > 0 q == 1;
			disp(strrep(['Middleman: (' sprintf('%d,', S) ')'], ',)', ')'));
			fprintf('Brokerage: %0.0f.\n--------------------\n', v);
		end
	end
