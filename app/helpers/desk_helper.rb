module DeskHelper
	# WARNING!! very hardcoded string (business logic), don't touch anithing in constants
	VERTICAL_LINES = [%w(A1 A2 A3 A4 A9 A10 A11 A12),
						%w(B1 B2 B3 B4 B9 B10 B11 B12),
						%w(C1 C2 C3 C4 C9 C10 C11 C12),
						%w(D1 D2 D3 D4 D9 D10 D11 D12),

						%w(E1 E2 E3 E4 E5 E6 E7 E8),
						%w(F1 F2 F3 F4 F5 F6 F7 F8),
						%w(G1 G2 G3 G4 G5 G6 G7 G8),
						%w(H1 H2 H3 H4 H5 H6 H7 H8),

						%w(K8 K7 K6 K5 K9 K10 K11 K12),
						%w(L8 L7 L6 L5 L9 L10 L11 L12),
						%w(M8 M7 M6 M5 M9 M10 M11 M12),
						%w(N8 N7 N6 N5 N9 N10 N11 N12)]

	HORIZONTAL_LINE = [%w(A1 B1 C1 D1 E1 F1 G1 H1),
						%w(A2 B2 C2 D2 E2 F2 G2 H2),
						%w(A3 B3 C3 D3 E3 F3 G3 H3),
						%w(A4 B4 C4 D4 E4 F4 G4 H4),

						%w(H8 G8 F8 E8 K8 L8 M8 N8),
						%w(H7 G7 F7 E7 K7 L7 M7 N7),
						%w(H6 G6 F6 E6 K6 L6 M6 N6),
						%w(H5 G5 F5 E5 K5 L5 M5 N5),

						%w(N12 M12 L12 K12 D12 C12 B12 A12),
						%w(N11 M11 L11 K11 D11 C11 B11 A11),
						%w(N10 M10 L10 K10 D10 C10 B10 A10),
						%w(N9 M9 L9 K9 D9 C9 B9 A9)]

	DIAGONALS = [%w(G1 H2),
					%w(F1 G2 H3),
					%w(E1 F2 G3 H4),
					%w(D1 E2 F3 G4 H5),
					%w(C1 D2 E3 F4 G5 H6),
					%w(B1 C2 D3 E4 F5 G6 H7),
					%w(B1 A2),
					%w(C1 B2 A3),
					%w(D1 C2 B3 A4),
					%w(E1 D2 C3 B4 A9),
					%w(F1 E2 D3 C4 B9 A10),
					%w(G1 F2 E3 D4 C9 B10 A11),
					%w(B12 A11),
					%w(C12 B11 A10),
					%w(D12 C11 B10 A9),
					%w(K12 D11 C10 B9 A4),
					%w(L12 K11 D10 C9 B4 A3),
					%w(M12 L11 K10 D9 C4 B3 A2),
					%w(M12 N11),
					%w(L12 M11 N10),
					%w(K12 L11 M10 N9),
					%w(D12 K11 L10 M9 N5),
					%w(C12 D11 K10 L9 M5 N6),
					%w(B12 C11 D10 K9 L5 M6 N7),
					%w(M8 N7),
					%w(L8 M7 N6),
					%w(K8 L7 M6 N5),
					%w(E8 K7 L6 M5 N9),
					%w(F8 E7 K6 L5 M9 N10),
					%w(G8 F7 E6 K5 L9 M10 N11),
					%w(G8 H7),
					%w(F8 G7 H6),
					%w(E8 F7 G6 H5),
					%w(K8 E7 F6 G5 H4),
					%w(L8 K7 E6 F5 G4 H3),
					%w(M8 L7 K6 E5 F4 G3 H2)]

	CENTER_DIAGONALS_WHITE = [%w(H1 G2 F3 E4),
								%w(A12 B11 C10 D9),
								%w(N8 M7 L6 K5)]

	CENTER_DIAGONALS_BLACK = [%w(A1 B2 C3 D4),
								%w(N12 M11 L10 K9),
								%w(H8 G7 F6 E5)]

	def vertical_lines
		
		return CENTER_DIAGONALS_BLACK
	end
end
