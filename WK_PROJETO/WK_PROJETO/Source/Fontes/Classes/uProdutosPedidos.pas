unit uProdutosPedidos;

interface

uses DB, SysUtils, uConexao, FireDAC.Comp.Client;

type
  TProdutosPedidos = class
  private
    FCodPedido: Integer;
    FCodProduto: Integer;
    FQtdeProduto: Integer;
    FValorTotal : Double;
    Conn : TConexao;
    FDsPesquisa: tDataSource;
    FQryPesquisa: TFDQuery;
    FQryInsert: TFDQuery;

    procedure SetCodPedido(const Value: Integer);
	  procedure SetCodProduto(const Value: Integer);
    procedure SetQtdeProduto(const Value: Integer);
    procedure SetValorTotal(const Value: Double);
    procedure SetDsPesquisa(const Value: tDataSource);
    procedure SetQryPesquisa(const Value: TFDQuery);
    procedure SetQryInsert(const Value: TFDQuery);
  public
    constructor Create(Conexao: TConexao);
    destructor Destroy; override;

    function GetCodPedido : Integer;

    property CodPedido : Integer read GetCodPedido write SetCodPedido;
   	property CodProduto : Integer read FCodProduto write SetCodProduto;
    property QtdeProduto : Integer read FQtdeProduto write SetQtdeProduto;
    property ValorTotal : Double read FValorTotal write SetValorTotal;

    property QryPesquisa : TFDQuery read FQryPesquisa write SetQryPesquisa;
    property QryInsert : TFDQuery read FQryInsert write SetQryInsert;

    property DsPesquisa : tDataSource read FDsPesquisa write SetDsPesquisa;
    function RetornaPedidosProdutos(CodPedido, CodProduto: Integer):Boolean;
    procedure InserirPedidosProduto(CodProduto,QtdeProduto,NumPedido: Integer; ValorTotal: Double);
    procedure InserirDadosGeraisPedidos(CodCliente,NumPedido: Integer; DtEmissao: TDateTime; ValorTotal: Double);

end;

implementation { TClientes }

uses uFuncoes;

constructor TProdutosPedidos.Create(Conexao: TConexao);
begin
  Conn                   := Conexao;
  QryPesquisa            := TFDQuery.Create(nil);
  QryInsert              := TFDQuery.Create(nil);
  DsPesquisa             := TDataSource.Create(nil);
  QryPesquisa.Connection := Conn.Conexao;
  DsPesquisa.DataSet     := QryPesquisa;
  QryInsert.Connection   := Conn.Conexao;
end;

destructor TProdutosPedidos.Destroy;
begin
  //FreeAndNil(Conn);
  inherited;
end;

function TProdutosPedidos.GetCodPedido: Integer;
begin
  Result := DsPesquisa.DataSet.FieldByName('COD_PEDIDO').AsInteger;
end;


procedure TProdutosPedidos.InserirDadosGeraisPedidos(CodCliente,NumPedido: Integer; DtEmissao: TDateTime; ValorTotal: Double);
begin
  with QryInsert  do
  begin
    Close;
    SQL.Text := 'INSERT INTO WK_BD.TB_PEDIDOS_GERAIS(DT_EMISSAO,COD_CLIENTE,VLR_TOTAL_PEDIDO,NUM_PEDIDO) '+
                'VALUES(:DT_EMISSAO,:COD_CLIENTE,:VLR_TOTAL_PEDIDO,:NUM_PEDIDO)';
    Params.ParamByName('DT_EMISSAO').AsDateTime    := DtEmissao;
    Params.ParamByName('COD_CLIENTE').AsInteger    := CodCliente;
    Params.ParamByName('VLR_TOTAL_PEDIDO').AsFloat := ValorTotal;
    Params.ParamByName('NUM_PEDIDO').AsInteger     := NumPedido;

    try
      ExecSQL;
    except
      //MENSAGEM ERRO
    end;
  end;
end;

procedure TProdutosPedidos.InserirPedidosProduto(CodProduto,QtdeProduto,NumPedido: Integer; ValorTotal: Double);
begin
  with QryInsert  do
  begin
    Close;
    SQL.Text := 'INSERT INTO WK_BD.TB_PEDIDOS_PRODUTOS(COD_PRODUTO,QTDE_PRODUTO,VLR_TOTAL_PEDIDO,NUM_PEDIDO) '+
                'VALUES(:COD_PRODUTO,:QTDE_PRODUTO,:VLR_TOTAL_PEDIDO,:NUM_PEDIDO)';
    Params.ParamByName('COD_PRODUTO').AsInteger      := CodProduto;
    Params.ParamByName('QTDE_PRODUTO').AsInteger     := QtdeProduto;
    Params.ParamByName('VLR_TOTAL_PEDIDO').AsFloat   := ValorTotal;
    Params.ParamByName('NUM_PEDIDO').AsInteger       := NumPedido;

    try
      ExecSQL;
    except
      //MENSAGEM ERRO
    end;
  end;
end;

function TProdutosPedidos.RetornaPedidosProdutos(CodPedido,CodProduto: Integer): Boolean;
begin
  with QryPesquisa do
  begin
    Close;
    SQL.Text := 'SELECT * FROM WK_BD.TB_PEDIDOS_PRODUTOS WHERE 1=1 ';

    if CodPedido > 0 then
    begin
      SQL.Add(' AND COD_PEDIDO = :COD_PEDIDO');
      Params.ParamByName('COD_PEDIDO').Value := CodPedido;
    end;

    if CodProduto > 0 then
    begin
      SQL.Add(' AND COD_PRODUTO = :COD_PRODUTO');
      Params.ParamByName('COD_PRODUTO').Value := CodProduto;
    end;

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

procedure TProdutosPedidos.SetCodPedido(const Value: Integer);
begin
  FCodPedido := Value;
end;

procedure TProdutosPedidos.SetCodProduto(const Value: Integer);
begin
  FCodProduto := Value;
end;

procedure TProdutosPedidos.SetDsPesquisa(const Value: tDataSource);
begin
  FDsPesquisa := Value;
end;

procedure TProdutosPedidos.SetQtdeProduto(const Value: Integer);
begin
  FQtdeProduto := Value;
end;

procedure TProdutosPedidos.SetValorTotal(const Value: Double);
begin
  FValorTotal := Value;
end;

procedure TProdutosPedidos.SetQryInsert(const Value: TFDQuery);
begin
  FQryInsert := Value;
end;

procedure TProdutosPedidos.SetQryPesquisa(const Value: TFDQuery);
begin
  FQryPesquisa := Value;
end;

end.
