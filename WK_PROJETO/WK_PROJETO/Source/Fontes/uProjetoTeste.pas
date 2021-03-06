unit uProjetoTeste;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Comp.UI,uConexao, uClientes, uProdutos,uProdutosPedidos, uFuncoes,
  Datasnap.DBClient;

type
  TFrmPrincipal = class(TForm)
    FDMySQLDriver: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    GrdPedidos: TDBGrid;
    BtnGravarPedido: TBitBtn;
    dbNomeCliente: TDBLookupComboBox;
    lblCliente: TLabel;
    lblCodProduto: TLabel;
    FDConexao: TFDConnection;
    edtCodProduto: TEdit;
    lblQuantidade: TLabel;
    lblValorUnitario: TLabel;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    cdsProdutos: TClientDataSet;
    cdsProdutosCOD_PRODUTO: TIntegerField;
    cdsProdutosDESC_PRODUTO: TStringField;
    cdsProdutosQTDE_PRODUTO: TIntegerField;
    cdsProdutosVLR_UNITARIO: TFloatField;
    cdsProdutosVLR_TOTAL: TFloatField;
    DsProdutos: TDataSource;
    btnGravarProduto: TBitBtn;
    cdsProdutosNUM_PEDIDO: TStringField;
    lblValorTotalGeral: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure BtnGravarPedidoClick(Sender: TObject);
    procedure btnGravarProdutoClick(Sender: TObject);
    procedure dbNomeClienteExit(Sender: TObject);
    procedure GrdPedidosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    Conexao : TConexao;
    Clientes : TClientes;
    Produtos : TProdutos;
    ProdutosPedidos : TProdutosPedidos;
  end;

var
  FrmPrincipal: TFrmPrincipal;
  iCodProduto,iCodPedido, iCodCliente, iNumPedido: Integer;
  rPrecoUnitario: Double;
  sDescProduto: String;


implementation

{$R *.dfm}

procedure TFrmPrincipal.btnGravarProdutoClick(Sender: TObject);
begin
  iCodProduto    := Produtos.GetCodProduto;
  rPrecoUnitario := Produtos.GetPrecoUnitario;
  sDescProduto   := Produtos.GetDescProduto;
  //Preenchendo Grid Produtos
  cdsProdutos.Append;
  cdsProdutos.FieldByName('COD_PRODUTO').AsInteger  := iCodProduto;
  cdsProdutos.FieldByName('DESC_PRODUTO').AsString  := sDescProduto;
  cdsProdutos.FieldByName('QTDE_PRODUTO').AsInteger := StrToInt(edtQuantidade.Text);
  cdsProdutos.FieldByName('VLR_UNITARIO').AsFloat   := Produtos.GetPrecoUnitario; //FormatFloat('#0.#0',Produtos.GetPrecoUnitario);
  cdsProdutos.FieldByName('VLR_TOTAL').AsFloat      := (StrToInt(edtQuantidade.Text) * rPrecoUnitario); //FormatFloat('#0.#0',Produtos.GetPrecoUnitario);
  cdsProdutos.Post;
  edtCodProduto.Text := Branco;
  edtQuantidade.Text := Branco;
  edtValorUnitario.Text := Branco;
end;

procedure TFrmPrincipal.dbNomeClienteExit(Sender: TObject);
begin
  iCodCliente := dbNomeCliente.KeyValue;
end;

procedure TFrmPrincipal.BtnGravarPedidoClick(Sender: TObject);
var
  rValorTotal, rValorTotalGeral : Double;
begin
  rValorTotal      := 0;
  rValorTotalGeral := 0;
  ProdutosPedidos.RetornaPedidosProdutos(0,0);
  iNumPedido := iif(ProdutosPedidos.GetCodPedido = 0,1,ProdutosPedidos.GetCodPedido + 1);

  try
    with cdsProdutos do
    begin
      First;
      while not Eof do
      begin
        rValorTotal := FieldByName('VLR_TOTAL').AsFloat;
        rValorTotalGeral := rValorTotalGeral + rValorTotal;
        ProdutosPedidos.InserirPedidosProduto(FieldByName('COD_PRODUTO').AsInteger,FieldByName('QTDE_PRODUTO').AsInteger,iNumPedido,rValorTotal);
        Next;
      end;
    end;
    ProdutosPedidos.InserirDadosGeraisPedidos(iCodCliente,iNumPedido,Now,rValorTotalGeral);
    lblValorTotalGeral.Caption := lblValorTotalGeral.Caption + FloatToStr(rValorTotalGeral);
    ShowMessage('Pedido registrado com sucesso!');
  except on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFrmPrincipal.edtCodProdutoExit(Sender: TObject);
begin
  Produtos.RetornaProdutos(StrToInt(edtCodProduto.Text),Branco,'DESC_PRODUTO');
  edtValorUnitario.Text := FormatFloat('#0.#0',Produtos.GetPrecoUnitario);
  edtValorUnitario.Enabled := False;
  edtQuantidade.SetFocus;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  Conexao := TConexao.Create(FDConexao);
  Conexao.Servidor := 'localhost';
  Conexao.Base     := 'WK_BD';
  Conexao.Login    := 'root';
  Conexao.Porta    := '3306';
  Conexao.Senha    := Branco;
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  Conexao.Destroy;
  Clientes.Destroy;
  Produtos.Destroy;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
 if Conexao.conectar_banco then
 begin
   Clientes := TClientes.Create(Conexao);
   Clientes.RetornaClientes(0,Branco,'NOME');
   dbNomeCliente.ListSource := Clientes.DsPesquisa;
   dbNomeCliente.ListField  := 'NOME';
   dbNomeCliente.KeyField   := 'CODIGO';
   Produtos                 := TProdutos.Create(Conexao);
   ProdutosPedidos          := TProdutosPedidos.Create(Conexao);
 end
 else
   ShowMessage('Erro');
end;

procedure TFrmPrincipal.GrdPedidosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if MessageDlg('Deseja Excluir esse item do Pedido',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    begin
      cdsProdutos.Delete;
      //cdsProdutos.Post;
    end;
  end;
end;

end.

