unit uProdutos;

interface

uses DB, SysUtils, uConexao, FireDAC.Comp.Client;

type
  TProdutos = class
  private
    FCodProduto: integer;
    FDescProduto: string;
    FPrecoUnitario : Double;
    Conn : TConexao;
    FDsPesquisa: tDataSource;
    FQryPesquisa: TFDQuery;

    procedure SetCodProduto(const Value: integer);
    procedure SetDescProduto(const Value: string);

    procedure SetPrecoUnitario(const Value: Double);
    procedure SetDsPesquisa(const Value: tDataSource);
    procedure SetQryPesquisa(const Value: TFDQuery);

  public
    constructor Create(Conexao: TConexao);
    destructor Destroy; override;

    function GetCodProduto: Integer;
    function GetDescProduto: string;
    function GetPrecoUnitario : Double;

    property CodProduto : Integer read GetCodProduto write SetCodProduto;
    property DescProduto : string read GetDescProduto write SetDescProduto;
    property PrecoUnitario : Double read GetPrecoUnitario write SetPrecoUnitario;

    property QryPesquisa : TFDQuery read FQryPesquisa write SetQryPesquisa;
    property DsPesquisa : tDataSource read FDsPesquisa write SetDsPesquisa;
    function RetornaProdutos(Codigo: Integer; Nome,OrderBy: String):Boolean;

end;

implementation { TClientes }

uses uFuncoes;

constructor TProdutos.Create(Conexao: TConexao);
begin
  Conn            := Conexao;
  QryPesquisa     := TFDQuery.Create(nil);
  DsPesquisa      := TDataSource.Create(nil);
  QryPesquisa.Connection := Conn.Conexao;
  DsPesquisa.DataSet := QryPesquisa;
end;

destructor TProdutos.Destroy;
begin
  //FreeAndNil(Conn);
  inherited;
end;

function TProdutos.GetCodProduto: Integer;
begin
  Result := DsPesquisa.DataSet.FieldByName('COD_PRODUTO').AsInteger;
end;

function TProdutos.GetDescProduto: string;
begin
  Result := DsPesquisa.DataSet.FieldByName('DESC_PRODUTO').AsString;
end;

function TProdutos.GetPrecoUnitario: Double;
begin
  Result := DsPesquisa.DataSet.FieldByName('PRECO_UNITARIO').AsFloat;
end;

function TProdutos.RetornaProdutos(Codigo: Integer; Nome,OrderBy: String): Boolean;
begin
  Nome := iif(Nome = Branco,Branco,'%'+Nome+'%');
  with QryPesquisa do
  begin
    Close;
    SQL.Text := 'SELECT * FROM WK_BD.TB_PRODUTOS WHERE 1=1 ';

    if Codigo > 0 then
    begin
      SQL.Add(' AND COD_PRODUTO = :COD_PRODUTO');
      Params.ParamByName('COD_PRODUTO').Value := Codigo;
    end;

    if Nome <> Branco then
      SQL.Add(' AND DESC_PRODUTO LIKE ' + QuotedStr(Nome));

    if OrderBy <> Branco then
      sql.add(' ORDER BY '+OrderBy);

    try
      Open;
      if not Eof then
        Result := True
      else
        Result := False;
    except
       Result := False;
    end;
  end;
end;

procedure TProdutos.SetCodProduto(const Value: integer);
begin
  FCodProduto := Value;
end;

procedure TProdutos.SetDsPesquisa(const Value: tDataSource);
begin
  FDsPesquisa := Value;
end;

procedure TProdutos.SetPrecoUnitario(const Value: Double);
begin
  FPrecoUnitario := Value;
end;

procedure TProdutos.SetDescProduto(const Value: string);
begin
  FDescProduto := Value;
end;

procedure TProdutos.SetQryPesquisa(const Value: TFDQuery);
begin
  FQryPesquisa := Value;
end;

end.
