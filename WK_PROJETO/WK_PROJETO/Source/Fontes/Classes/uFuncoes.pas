unit uFuncoes;

interface
CONST
   Branco = '';

function IIF(Condicao: Boolean; Verdadeiro: Variant; Falso: Variant):Variant;

implementation

function IIF(Condicao: Boolean; Verdadeiro: Variant; Falso: Variant):Variant;
Begin
  if Condicao
  then Result := Verdadeiro
  else Result := Falso;
end;


end.
