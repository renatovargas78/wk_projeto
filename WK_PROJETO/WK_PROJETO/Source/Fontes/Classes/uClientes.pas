unit uClientes;

interface

uses DB, SysUtils, uConexao, FireDAC.Comp.Client;

type
  TClientes = class
  private
    FCodigo: integer;
    FNome: string;
    FCidade: string;
    FUF: string;
    Conn : TConexao;
    FDsPesquisa: TDataSource;
    FQryPesquisa: TFDQuery;
    procedure SetCodigo(const Value: integer);
    procedure SetNome(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetUF(const Value: string);
    procedure SetDsPesquisa(const Value: tDataSource);
    procedure SetQryPesquisa(const Value: TFDQuery);

  public
    constructor Create(Conexao: TConexao);
    destructor Destroy; override;
    property Codigo : Integer read FCodigo write SetCodigo;
    property Nome : string read FNome write SetNome;
    property Cidade : string read FCidade write SetCidade;
    property UF : string read FUF write SetUF;

    property QryPesquisa : TFDQuery read FQryPesquisa write SetQryPesquisa;
    property DsPesquisa : tDataSource read FDsPesquisa write SetDsPesquisa;
    function RetornaClientes(Codigo: Integer; Nome,OrderBy: String):Boolean;
end;

implementation { TClientes }

uses uFuncoes;

constructor TClientes.Create(Conexao: TConexao);
begin
  Conn            := Conexao;
  QryPesquisa     := TFDQuery.Create(nil);
  DsPesquisa      := TDataSource.Create(nil);
  QryPesquisa.Connection := Conn.Conexao;
  DsPesquisa.DataSet := QryPesquisa;
end;

destructor TClientes.Destroy;
begin
  //FreeAndNil(Conn);
  inherited;
end;

function TClientes.RetornaClientes(Codigo: Integer; Nome,OrderBy: String): Boolean;
begin
  Nome := iif(Nome = Branco,Branco,'%'+Nome+'%');
  with QryPesquisa do
  begin
    Close;
    SQL.Text := 'SELECT * FROM WK_BD.TB_CLIENTES WHERE 1=1 ';

    if Codigo > 0 then
    begin
      SQL.Add(' AND CODIGO = :CODIGO');
      Params.ParamByName('CODIGO').Value := Codigo;
    end;

    if Nome <> Branco then
      SQL.Add(' AND NOME LIKE ' + QuotedStr(Nome));

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

procedure TClientes.SetCodigo(const Value: integer);
begin
  FCodigo := Value;
end;

procedure TClientes.SetDsPesquisa(const Value: tDataSource);
begin
  FDsPesquisa := Value;
end;

procedure TClientes.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TClientes.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TClientes.SetUF(const Value: string);
begin
  FUF := Value;
end;

procedure TClientes.SetQryPesquisa(const Value: TFDQuery);
begin
  FQryPesquisa := Value;
end;

end.
