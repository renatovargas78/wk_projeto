object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Projeto Teste WK Consultoria'
  ClientHeight = 391
  ClientWidth = 776
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblCliente: TLabel
    Left = 16
    Top = 44
    Width = 33
    Height = 13
    Caption = 'Cliente'
  end
  object lblCodProduto: TLabel
    Left = 299
    Top = 44
    Width = 61
    Height = 13
    Caption = 'Cod.Produto'
  end
  object lblQuantidade: TLabel
    Left = 423
    Top = 44
    Width = 56
    Height = 13
    Caption = 'Quantidade'
  end
  object lblValorUnitario: TLabel
    Left = 552
    Top = 44
    Width = 64
    Height = 13
    Caption = 'Valor Unitario'
  end
  object lblValorTotalGeral: TLabel
    Left = 16
    Top = 368
    Width = 102
    Height = 13
    Caption = 'Valor Total Geral : R$'
  end
  object GrdPedidos: TDBGrid
    Left = 16
    Top = 87
    Width = 656
    Height = 274
    DataSource = DsProdutos
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnKeyDown = GrdPedidosKeyDown
  end
  object BtnGravarPedido: TBitBtn
    Left = 679
    Top = 87
    Width = 90
    Height = 22
    Caption = '&Gravar Pedido'
    TabOrder = 1
    OnClick = BtnGravarPedidoClick
  end
  object dbNomeCliente: TDBLookupComboBox
    Left = 16
    Top = 60
    Width = 274
    Height = 21
    TabOrder = 2
    OnExit = dbNomeClienteExit
  end
  object edtCodProduto: TEdit
    Left = 296
    Top = 60
    Width = 121
    Height = 21
    TabOrder = 3
    OnExit = edtCodProdutoExit
  end
  object edtQuantidade: TEdit
    Left = 423
    Top = 60
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object edtValorUnitario: TEdit
    Left = 552
    Top = 60
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object btnGravarProduto: TBitBtn
    Left = 679
    Top = 59
    Width = 90
    Height = 22
    Caption = '&Gravar Produto'
    TabOrder = 6
    OnClick = btnGravarProdutoClick
  end
  object FDMySQLDriver: TFDPhysMySQLDriverLink
    VendorLib = 'C:\WK_PROJETO\DLL\libmysql.dll'
    Left = 96
    Top = 168
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 272
    Top = 168
  end
  object FDConexao: TFDConnection
    Left = 184
    Top = 168
  end
  object cdsProdutos: TClientDataSet
    PersistDataPacket.Data = {
      8B0000009619E0BD0100000018000000050000000000030000008B000B434F44
      5F50524F4455544F04000100000000000C444553435F50524F4455544F010049
      00000001000557494454480200020064000C515444455F50524F4455544F0400
      0100000000000C564C525F554E49544152494F080004000000000009564C525F
      544F54414C08000400000000000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 72
    Top = 248
    object cdsProdutosCOD_PRODUTO: TIntegerField
      DisplayLabel = 'Cod.Produto'
      DisplayWidth = 15
      FieldName = 'COD_PRODUTO'
    end
    object cdsProdutosDESC_PRODUTO: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      DisplayWidth = 49
      FieldName = 'DESC_PRODUTO'
      Size = 50
    end
    object cdsProdutosQTDE_PRODUTO: TIntegerField
      DisplayLabel = 'Qtde. Produto'
      DisplayWidth = 15
      FieldName = 'QTDE_PRODUTO'
    end
    object cdsProdutosVLR_UNITARIO: TFloatField
      DisplayLabel = 'Valor Unit'#225'rio'
      DisplayWidth = 21
      FieldName = 'VLR_UNITARIO'
      DisplayFormat = '###.##'
    end
    object cdsProdutosVLR_TOTAL: TFloatField
      DisplayLabel = 'Valor Total'
      DisplayWidth = 22
      FieldName = 'VLR_TOTAL'
      DisplayFormat = '###.##'
    end
    object cdsProdutosNUM_PEDIDO: TStringField
      FieldKind = fkCalculated
      FieldName = 'NUM_PEDIDO'
      Visible = False
      Size = 10
      Calculated = True
    end
  end
  object DsProdutos: TDataSource
    DataSet = cdsProdutos
    Left = 152
    Top = 248
  end
end
