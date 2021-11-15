object DataDialog: TDataDialog
  Left = 227
  Top = 108
  ActiveControl = seData
  BorderIcons = [biMinimize, biMaximize]
  ClientHeight = 369
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object paTop: TPanel
    Left = 0
    Top = 0
    Width = 546
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object gbXErr: TGroupBox
      Left = 5
      Top = 5
      Width = 261
      Height = 46
      Caption = 'X error values'
      TabOrder = 0
      object rbXNoErr: TRadioButton
        Left = 10
        Top = 20
        Width = 61
        Height = 17
        Caption = 'No'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rgErrClick
      end
      object rbXSymErr: TRadioButton
        Left = 80
        Top = 20
        Width = 81
        Height = 17
        Caption = 'Symmetric'
        TabOrder = 1
        OnClick = rgErrClick
      end
      object rbXAsymErr: TRadioButton
        Left = 170
        Top = 20
        Width = 86
        Height = 17
        Caption = 'Asymmetric'
        TabOrder = 2
        OnClick = rgErrClick
      end
    end
    object gbYErr: TGroupBox
      Left = 270
      Top = 5
      Width = 261
      Height = 46
      Caption = 'Y error values'
      TabOrder = 1
      object rbYNoErr: TRadioButton
        Left = 10
        Top = 20
        Width = 61
        Height = 17
        Caption = 'No'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rgErrClick
      end
      object rbYSymerr: TRadioButton
        Left = 80
        Top = 20
        Width = 81
        Height = 17
        Caption = 'Symmetric'
        TabOrder = 1
        OnClick = rgErrClick
      end
      object rbYAsymerr: TRadioButton
        Left = 170
        Top = 20
        Width = 86
        Height = 17
        Caption = 'Asymmetric'
        TabOrder = 2
        OnClick = rgErrClick
      end
    end
  end
  object paBottom: TPanel
    Left = 0
    Top = 300
    Width = 546
    Height = 69
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      546
      69)
    object sbCol: TSpeedButton
      Left = 70
      Top = 5
      Width = 26
      Height = 26
      Hint = 'Toggle select mode (F4)'
      AllowAllUp = True
      GroupIndex = 1
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04D4D4D4D4D4D
        4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D
        4D4D4D4D4D4D4D4D4D4D5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F
        5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F4D4D4DFFFFFF
        FFFFFFFFFFFFFFFFFFDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FFFFFFFFFFF
        FFFFFFFFFFFFFF4D4D4D5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFC5C5C5C5C5C5C5
        C5C5C5C5C5C5C5C5C5C5C5FFFFFFFFFFFFFFFFFFFFFFFF5F5F5F4D4D4DFFFFFF
        4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D
        4D4D4D4DFFFFFF4D4D4D5F5F5FFFFFFF5F5F5F5F5F5F5F5F5FC5C5C55F5F5F5F
        5F5F5F5F5F5F5F5FC5C5C55F5F5F5F5F5F5F5F5FFFFFFF5F5F5F4D4D4DFFFFFF
        FFFFFFFFFFFFFFFFFFDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FFFFFFFFFFF
        FFFFFFFFFFFFFF4D4D4D5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFC5C5C5C5C5C5C5
        C5C5C5C5C5C5C5C5C5C5C5FFFFFFFFFFFFFFFFFFFFFFFF5F5F5F4D4D4DFFFFFF
        4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D
        4D4D4D4DFFFFFF4D4D4D5F5F5FFFFFFF5F5F5F5F5F5F5F5F5FC5C5C55F5F5F5F
        5F5F5F5F5F5F5F5FC5C5C55F5F5F5F5F5F5F5F5FFFFFFF5F5F5F4D4D4DFFFFFF
        FFFFFFFFFFFFFFFFFFDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FFFFFFFFFFF
        FFFFFFFFFFFFFF4D4D4D5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFC5C5C5C5C5C5C5
        C5C5C5C5C5C5C5C5C5C5C5FFFFFFFFFFFFFFFFFFFFFFFF5F5F5F4D4D4DFFFFFF
        4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D
        4D4D4D4DFFFFFF4D4D4D5F5F5FFFFFFF5F5F5F5F5F5F5F5F5FC5C5C55F5F5F5F
        5F5F5F5F5F5F5F5FC5C5C55F5F5F5F5F5F5F5F5FFFFFFF5F5F5F4D4D4DFFFFFF
        FFFFFFFFFFFFFFFFFFDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FFFFFFFFFFF
        FFFFFFFFFFFFFF4D4D4D5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFC5C5C5C5C5C5C5
        C5C5C5C5C5C5C5C5C5C5C5FFFFFFFFFFFFFFFFFFFFFFFF5F5F5F4D4D4DFFFFFF
        4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D
        4D4D4D4DFFFFFF4D4D4D5F5F5FFFFFFF5F5F5F5F5F5F5F5F5FC5C5C55F5F5F5F
        5F5F5F5F5F5F5F5FC5C5C55F5F5F5F5F5F5F5F5FFFFFFF5F5F5F4D4D4DFFFFFF
        FFFFFFFFFFFFFFFFFFDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FFFFFFFFFFF
        FFFFFFFFFFFFFF4D4D4D5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFC5C5C5C5C5C5C5
        C5C5C5C5C5C5C5C5C5C5C5FFFFFFFFFFFFFFFFFFFFFFFF5F5F5F4D4D4DFFFFFF
        4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D
        4D4D4D4DFFFFFF4D4D4D5F5F5FFFFFFF5F5F5F5F5F5F5F5F5FC5C5C55F5F5F5F
        5F5F5F5F5F5F5F5FC5C5C55F5F5F5F5F5F5F5F5FFFFFFF5F5F5F4D4D4DFFFFFF
        FFFFFFFFFFFFFFFFFFDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FFFFFFFFFFF
        FFFFFFFFFFFFFF4D4D4D5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFC5C5C5C5C5C5C5
        C5C5C5C5C5C5C5C5C5C5C5FFFFFFFFFFFFFFFFFFFFFFFF5F5F5F4D4D4DFFFFFF
        4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D4D4D4D4D4D4D4DDE9B1F4D4D4D4D4D
        4D4D4D4DFFFFFF4D4D4D5F5F5FFFFFFF5F5F5F5F5F5F5F5F5FC5C5C55F5F5F5F
        5F5F5F5F5F5F5F5FC5C5C55F5F5F5F5F5F5F5F5FFFFFFF5F5F5F4D4D4DFFFFFF
        FFFFFFFFFFFFFFFFFFDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FDE9B1FFFFFFFFFFF
        FFFFFFFFFFFFFF4D4D4D5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFC5C5C5C5C5C5C5
        C5C5C5C5C5C5C5C5C5C5C5FFFFFFFFFFFFFFFFFFFFFFFF5F5F5F4D4D4D4D4D4D
        4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D
        4D4D4D4D4D4D4D4D4D4D5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F
        5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbColClick
    end
    object sbNext: TSpeedButton
      Left = 150
      Top = 5
      Width = 26
      Height = 26
      Hint = 'Find / Replace next (F3)'
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC009459E09459E09459EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC06C6C6C6C6C6C6C6C6CC0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC009459E09459E09459EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC06C6C6C6C6C6C6C6C6CC0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC009459E09459E09459E74411A74411A74411AC0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC06C6C6C6C6C6C6C
        6C6C5D5D5D5D5D5D5D5D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC009459E74411AAFC3AFAFC3AFAFC3AF74411AC0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC06C6C6C5D
        5D5DCFCFCFCFCFCFCFCFCF5D5D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC074411AAFC3AFB9CDB9B9CDB9B9CDB9AFC3AF7441
        1AC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC05D5D5DCF
        CFCFD7D7D7D7D7D7D7D7D7CFCFCF5D5D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC074411AAFC3AFB9CDB9C4D8C4B9CDB9AFC3AF7441
        1AC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC05D5D5DCF
        CFCFD7D7D7DFDFDFD7D7D7CFCFCF5D5D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC074411AAFC3AFB9CDB9B9CDB9B9CDB9AFC3AF7441
        1AC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC05D5D5DCF
        CFCFD7D7D7D7D7D7D7D7D7CFCFCF5D5D5DC0DCC0C0DCC0C0DCC0C0DCC0605D5D
        605D5D605D5DC0DCC0C0DCC0C0DCC074411AAFC3AFAFC3AFAFC3AF74411AC0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC07A77777A77777A7777C0DCC0C0DCC0C0DCC05D
        5D5DCFCFCFCFCFCFCFCFCF5D5D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC074411A74411A74411AC0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC05D5D5D5D5D5D5D5D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0605D5D
        605D5D605D5D605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC00808
        D4C0DCC0C0DCC0C0DCC0C0DCC07A77777A77777A77777A7777C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC06E6E6EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC00808
        D40808D4C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC06E6E6E6E6E6EC0DCC0C0DCC0C0DCC0605D5D
        605D5D605D5D605D5DC0DCC0C0DCC00808D40808D40808D40808D40808D40808
        D40808D40808D4C0DCC0C0DCC07A77777A77777A77777A7777C0DCC0C0DCC06E
        6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6EC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC00808D40808D40808D40808D40808D40808
        D40808D40808D40808D4C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC06E
        6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6EC0DCC0605D5D
        605D5D605D5DC0DCC0C0DCC0C0DCC00808D40808D40808D40808D40808D40808
        D40808D40808D4C0DCC0C0DCC07A77777A77777A7777C0DCC0C0DCC0C0DCC06E
        6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6EC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC00808
        D40808D4C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC06E6E6E6E6E6EC0DCC0C0DCC0C0DCC0605D5D
        605D5D605D5D605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC00808
        D4C0DCC0C0DCC0C0DCC0C0DCC07A77777A77777A77777A7777C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC06E6E6EC0DCC0C0DCC0C0DCC0}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = FindNext
    end
    object sbReplace: TSpeedButton
      Left = 125
      Top = 5
      Width = 26
      Height = 26
      Hint = 'Replace text (Ctrl+R)'
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC0C0DCC009459E09459E09459EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC07C7C7C7C7C7C7C7C7CC0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC009459E09459E09459EC0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC07C7C7C7C7C7C7C
        7C7CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC009459E09459E09459E74411A74411A74411AC0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC07C7C7C7C
        7C7C7C7C7C717171717171717171C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC009459E74411AAFC3AFAFC3AFAFC3AF7441
        1AC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC07C
        7C7C717171CFCFCFCFCFCFCFCFCF717171C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC074411AAFC3AFB9CDB9B9CDB9B9CDB9AFC3
        AF74411AC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC071
        7171CFCFCFD6D6D6D6D6D6D6D6D6CFCFCF717171C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC074411AAFC3AFB9CDB9C4D8C4B9CDB9AFC3
        AF74411AC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC071
        7171CFCFCFD6D6D6DEDEDED6D6D6CFCFCF717171C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC074411AAFC3AFB9CDB9B9CDB9B9CDB9AFC3
        AF74411AC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC071
        7171CFCFCFD6D6D6D6D6D6D6D6D6CFCFCF717171C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC074411AAFC3AFAFC3AFAFC3AF7441
        1AC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0717171CFCFCFCFCFCFCFCFCF717171C0DCC0C0DCC0C0DCC0C0DCC07E4B21
        C0DCC0C0DCC07E4B21C0DCC0C0DCC0C0DCC0C0DCC074411A74411A74411AC0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0787878C0DCC0C0DCC0787878C0DCC0C0DCC0C0
        DCC0C0DCC0717171717171717171C0DCC0C0DCC0C0DCC0C0DCC0C0DCC07E4B21
        C0DCC0C0DCC07E4B21C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0787878C0DCC0C0DCC0787878C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC07E4B21
        7E4B217E4B217E4B21C0DCC0C0DCC0C0DCC0007EBAC0DCC0C0DCC02121BA2121
        BA2121BA2121BAC0DCC0C0DCC0787878787878787878787878C0DCC0C0DCC0C0
        DCC0848484C0DCC0C0DCC0939393939393939393939393C0DCC0C0DCC07E4B21
        C0DCC0C0DCC07E4B21C0DCC0C0DCC0C0DCC0C0DCC0007EBAC0DCC02121BAC0DC
        C0C0DCC02121BAC0DCC0C0DCC0787878C0DCC0C0DCC0787878C0DCC0C0DCC0C0
        DCC0C0DCC0848484C0DCC0939393C0DCC0C0DCC0939393C0DCC0C0DCC07E4B21
        C0DCC0C0DCC07E4B21C0DCC0007EBA007EBA007EBA007EBA007EBAC0DCC02121
        BAC0DCC0C0DCC0C0DCC0C0DCC0787878C0DCC0C0DCC0787878C0DCC084848484
        8484848484848484848484C0DCC0939393C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        7E4B217E4B21C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0007EBAC0DCC0C0DCC0C0DC
        C02121BAC0DCC0C0DCC0C0DCC0C0DCC0787878787878C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0848484C0DCC0C0DCC0C0DCC0939393C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0007EBAC0DCC0C0DCC02121BAC0DC
        C0C0DCC02121BAC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0848484C0DCC0C0DCC0939393C0DCC0C0DCC0939393C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC02121BA2121
        BA2121BA2121BAC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0939393939393939393939393C0DCC0}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbReplaceClick
    end
    object sbFind: TSpeedButton
      Left = 100
      Top = 5
      Width = 26
      Height = 26
      Hint = 'Find text (Ctrl+F)'
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC00A459E0A459E
        0A459EC0DCC0605D5D605D5D605D5D605D5D605D5D605D5D605D5DC0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0666666666666666666C0DCC0605D5D605D5D605D5D60
        5D5D605D5D605D5D605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC00A459EFFFFFF
        0A459E0A459EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0666666FFFFFF666666666666C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC00A459EFFFFFF
        FFFFFF0A459E0A459E605D5D605D5D605D5D605D5D605D5D605D5D605D5DC0DC
        C0C0DCC0C0DCC0C0DCC0666666FFFFFFFFFFFF666666666666605D5D605D5D60
        5D5D605D5D605D5D605D5D605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC00A459E
        FFFFFFFFFFFF0A459E0A459EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0666666FFFFFFFFFFFF666666666666C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        0A459EFFFFFFFFFFFF0A459E0A459E605D5D605D5DC0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0666666FFFFFFFFFFFF66666666666660
        5D5D605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC00A459EFFFFFFFFFFFF0A459E0A459E76431C76431C76431C76431CC0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0666666FFFFFFFFFFFF66666666
        6666666666666666666666666666C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC00A459EFFFFFF0A459E76431C889086889086889086B8CFB87643
        1CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0666666FFFFFF66666666
        6666949A93949A93949A93C4D9C4666666C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC00A459E76431CB8CFB8BBD3BBBBD3BBBBD3BBBBD3BBBBD3
        BB76431CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0666666666666C4
        D9C4C7DCC7C7DCC7C7DCC7C7DCC7C7DCC7666666C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0605D5D76431C8890868B938A8E968C8E968C8E968C8E968CBED6
        BEBBD3BB76431CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0605D5D666666949A9397
        9C95999E97999E97999E97999E97C9DEC9C7DCC7666666C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC076431CB8CFB8BBD3BBBED6BEC1D9C1C1D9C1C1D9C1BED6
        BEBBD3BB76431CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0666666C4D9C4C7
        DCC7C9DEC9CBE0CBCBE0CBCBE0CBC9DEC9C7DCC7666666C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0605D5D76431C8890868B938A8E968CC1D9C1C5DDC5C1D9C1BED6
        BEBBD3BB76431CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0605D5D666666949A9397
        9C95999E97CBE0CBCEE3CECBE0CBC9DEC9C7DCC7666666C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC076431CB8CFB8BBD3BBBED6BEC1D9C1C1D9C1C1D9C1BED6
        BEBBD3BB76431CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0666666C4D9C4C7
        DCC7C9DEC9CBE0CBCBE0CBCBE0CBC9DEC9C7DCC7666666C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0605D5D605D5D76431C8B938A8E968C8E968C8E968CBED6BEBED6
        BE76431CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0605D5D605D5D66666697
        9C95999E97999E97999E97C9DEC9C9DEC9666666C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC076431CBBD3BBBBD3BBBBD3BBBBD3BB7643
        1CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC066
        6666C7DCC7C7DCC7C7DCC7C7DCC7666666C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC076431C76431C76431C76431CC0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0666666666666666666666666C0DCC0C0DCC0C0DCC0C0DCC0}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbFindClick
    end
    object sbPaste: TSpeedButton
      Left = 10
      Top = 5
      Width = 26
      Height = 26
      Hint = 'Paste from clipboard (Ctrl+B)'
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC09C33029C33029C33029C33029C33029C33029C33029C33
        029C3302C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F4F4F4F4F4F4F
        4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4FC0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC09C330200FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF9C3302C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F4F4F80808080808080
        80808080808080808080808080808080808080804F4F4FC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC09C330200FFFF808080B34D1EB34D1EB34D1EB34D1EB34D1E8080
        8000FFFF9C3302C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F4F4F80808080808069
        69696969696969696969696969698080808080804F4F4FC0DCC0C0DCC0C0DCC0
        C0DCC00032FFFFFFFF00FFFFB34D1EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB34D
        1E00FFFF9C3302C0DCC0C0DCC0C0DCC0C0DCC0808080FFFFFF808080696969FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF6969698080804F4F4FC0DCC0C0DCC0C0DCC0
        0032FF0032FFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C0FFFFFFB34D
        1E00FFFF9C3302C0DCC0C0DCC0C0DCC0808080808080FFFFFFFFFFFFFFFFFFFF
        FFFFC0C0C0C0C0C0C0C0C0FFFFFF6969698080804F4F4FC0DCC0C0DCC00032FF
        0032FF0032FF0032FF0032FF0032FFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFB34D
        1E00FFFF9C3302C0DCC0C0DCC0808080808080808080808080808080808080C0
        C0C0FFFFFFFFFFFFFFFFFFFFFFFF6969698080804F4F4FC0DCC00032FF0032FF
        0032FF0032FF0032FF0032FF0032FFFFFFFFFFFFFFC0C0C0C0C0C0FFFFFFB34D
        1E00FFFF9C3302C0DCC0808080808080808080808080808080808080808080FF
        FFFFFFFFFFC0C0C0C0C0C0FFFFFF6969698080804F4F4FC0DCC0C0DCC00032FF
        0032FF0032FF0032FF0032FF0032FFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFB34D
        1E00FFFF9C3302C0DCC0C0DCC0808080808080808080808080808080808080C0
        C0C0FFFFFFFFFFFFFFFFFFFFFFFF6969698080804F4F4FC0DCC0C0DCC0C0DCC0
        0032FF0032FFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C0FFFFFFB34D
        1E00FFFF9C3302C0DCC0C0DCC0C0DCC0808080808080FFFFFFFFFFFFFFFFFFFF
        FFFFC0C0C0C0C0C0C0C0C0FFFFFF6969698080804F4F4FC0DCC0C0DCC0C0DCC0
        C0DCC00032FFFFFFFF00FFFFB34D1EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB34D
        1E00FFFF9C3302C0DCC0C0DCC0C0DCC0C0DCC0808080FFFFFF808080696969FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF6969698080804F4F4FC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC09C330200FFFF808080B34D1EB34D1EB34D1EB34D1EB34D1E8080
        8000FFFF9C3302C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F4F4F80808080808069
        69696969696969696969696969698080808080804F4F4FC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC09C330200FFFF00FFFF9C3302C0C0C0FFFFFFC0C0C09C330200FF
        FF00FFFF9C3302C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F4F4F8080808080804F
        4F4FC0C0C0FFFFFFC0C0C04F4F4F8080808080804F4F4FC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC09C33029C33029C33029C3302C0C0C09C33029C33029C33
        029C3302C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F4F4F4F4F4F4F
        4F4F4F4F4FC0C0C04F4F4F4F4F4F4F4F4F4F4F4FC0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC09C3302FFFFFFC0C0C0C0C0C09C3302C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F
        4F4FFFFFFFC0C0C0C0C0C04F4F4FC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC09C33029C33029C33029C33029C3302C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F
        4F4F4F4F4F4F4F4F4F4F4F4F4F4FC0DCC0C0DCC0C0DCC0C0DCC0}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbPasteClick
    end
    object sbSort: TSpeedButton
      Left = 40
      Top = 5
      Width = 26
      Height = 26
      Hint = 'Sort data by X values (Ctrl+S)'
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC02121BA
        2121BA2121BA2121BAC0DCC0C0DCC0C0DCC0C0DCC0C0DCC07D4A217D4A21C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC04F4F4F4F4F4F4F4F4F4F4F4FC0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC04F4F4F4F4F4FC0DCC0C0DCC0C0DCC0C0DCC0C0DCC02121BA
        C0DCC0C0DCC02121BAC0DCC0C0DCC0C0DCC0C0DCC07D4A21D88D50D88D507D4A
        21C0DCC0C0DCC0C0DCC0C0DCC04F4F4FC0DCC0C0DCC04F4F4FC0DCC0C0DCC0C0
        DCC0C0DCC04F4F4F9494949494944F4F4FC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        2121BAC0DCC0C0DCC0C0DCC0C0DCC0C0DCC07D4A21D88D50D88D50D88D50D88D
        507D4A21C0DCC0C0DCC0C0DCC0C0DCC04F4F4FC0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC04F4F4F9494949494949494949494944F4F4FC0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC02121BAC0DCC0C0DCC0C0DCC07D4A21D88D50D88D50D88D50D88D50D88D
        50D88D507D4A21C0DCC0C0DCC0C0DCC0C0DCC04F4F4FC0DCC0C0DCC0C0DCC04F
        4F4F9494949494949494949494949494949494944F4F4FC0DCC0C0DCC02121BA
        C0DCC0C0DCC02121BAC0DCC0C0DCC07D4A217D4A217D4A21D88D50D88D507D4A
        217D4A217D4A21C0DCC0C0DCC04F4F4FC0DCC0C0DCC04F4F4FC0DCC0C0DCC04F
        4F4F4F4F4F4F4F4F9494949494944F4F4F4F4F4F4F4F4FC0DCC0C0DCC02121BA
        2121BA2121BA2121BAC0DCC0C0DCC0C0DCC0C0DCC07D4A21DA945ADA91567D4A
        21C0DCC0C0DCC0C0DCC0C0DCC04F4F4F4F4F4F4F4F4F4F4F4FC0DCC0C0DCC0C0
        DCC0C0DCC04F4F4F9A9A9A9898984F4F4FC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC07D4A21DA9156D98F537D4A
        21C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC04F4F4F9898989696964F4F4FC0DCC0C0DCC0C0DCC0C0DCC07E4B21
        C0DCC0C0DCC07E4B21C0DCC0C0DCC0C0DCC0C0DCC07D4A21D98F53D88D507D4A
        21C0DCC0C0DCC0C0DCC0C0DCC04F4F4FC0DCC0C0DCC04F4F4FC0DCC0C0DCC0C0
        DCC0C0DCC04F4F4F9696969494944F4F4FC0DCC0C0DCC0C0DCC0C0DCC07E4B21
        C0DCC0C0DCC07E4B21C0DCC0C0DCC0C0DCC0C0DCC07D4A21D88D50D78B4D7D4A
        21C0DCC0C0DCC0C0DCC0C0DCC04F4F4FC0DCC0C0DCC04F4F4FC0DCC0C0DCC0C0
        DCC0C0DCC04F4F4F9494949292924F4F4FC0DCC0C0DCC0C0DCC0C0DCC07E4B21
        7E4B217E4B217E4B21C0DCC0C0DCC0C0DCC0C0DCC07D4A21D78B4DD688477D4A
        21C0DCC0C0DCC0C0DCC0C0DCC04F4F4F4F4F4F4F4F4F4F4F4FC0DCC0C0DCC0C0
        DCC0C0DCC04F4F4F9292928E8E8E4F4F4FC0DCC0C0DCC0C0DCC0C0DCC07E4B21
        C0DCC0C0DCC07E4B21C0DCC0C0DCC0C0DCC0C0DCC07D4A21D68847D586457D4A
        21C0DCC0C0DCC0C0DCC0C0DCC04F4F4FC0DCC0C0DCC04F4F4FC0DCC0C0DCC0C0
        DCC0C0DCC04F4F4F8E8E8E8D8D8D4F4F4FC0DCC0C0DCC0C0DCC0C0DCC07E4B21
        C0DCC0C0DCC07E4B21C0DCC0C0DCC0C0DCC0C0DCC07D4A217D4A217D4A217D4A
        21C0DCC0C0DCC0C0DCC0C0DCC04F4F4FC0DCC0C0DCC04F4F4FC0DCC0C0DCC0C0
        DCC0C0DCC04F4F4F4F4F4F4F4F4F4F4F4FC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        7E4B217E4B21C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC04F4F4F4F4F4FC0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbSortClick
    end
    object laLines: TLabel
      Left = 205
      Top = 0
      Width = 3
      Height = 13
    end
    object bbImport: TBitBtn
      Left = 10
      Top = 35
      Width = 166
      Height = 26
      Caption = 'Import data'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333333FFFFFFFFF333333000000000033333377777777773333330FFFFF
        FFF03333337F333333373333330FFFFFFFF03333337F3FF3FFF73333330F00F0
        00F03333F37F773777373330330FFFFFFFF03337FF7F3F3FF3F73339030F0800
        F0F033377F7F737737373339900FFFFFFFF03FF7777F3FF3FFF70999990F00F0
        00007777777F7737777709999990FFF0FF0377777777FF37F3730999999908F0
        F033777777777337F73309999990FFF0033377777777FFF77333099999000000
        3333777777777777333333399033333333333337773333333333333903333333
        3333333773333333333333303333333333333337333333333333}
      NumGlyphs = 2
      TabOrder = 2
      OnClick = bbImportClick
    end
    object CancelBtn: TBitBtn
      Left = 440
      Top = 30
      Width = 96
      Height = 31
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        BDD9C04049AF4049AFBDD9C0C0DCC0C0DCC0C0DCC0C0DCC0BDD9C04049AF4049
        AFBDD9C0C0DCC0C0DCC0C0DCC0C0DCC0BFDABF778077778077BFDABFC0DCC0C0
        DCC0C0DCC0C0DCC0BFDABF778077778077BFDABFC0DCC0C0DCC0C0DCC0BDD9C0
        3C44AF191AB0191AB03C44AFBDD9C0C0DCC0C0DCC0BDD9C03C44AF191AB0191A
        B03C44AFBDD9C0C0DCC0C0DCC0BFDABF757D75656665656665757D75BFDABFC0
        DCC0C0DCC0BFDABF757D75656665656665757D75BFDABFC0DCC0C0DCC04650B1
        1E1FB33B3BC83B3BC81E1FB43F47B1BDD9C0BDD9C03F47B11E1FB43C3CC83B3B
        C81E1FB44650B1C0DCC0C0DCC07C857C686A68818181818181696B69788078BF
        DABFBFDABF788078696B69828282818181696B697C857CC0DCC0C0DCC04852B3
        2324B64545CD4141CC4646CD2324B64149B24149B22324B64646CD4242CC4545
        CD2324B64852B3C0DCC0C0DCC07E877E6C6D6C8989898686868989896C6D6C79
        81797981796C6D6C8989898787878989896C6D6C7E877EC0DCC0C0DCC0BDD9C0
        444CB42829BA5050D14A4AD05050D12C2DBB2C2DBB5050D14A4AD05050D12829
        BA444CB4BDD9C0C0DCC0C0DCC0BFDABF7C847C7172719090908D8D8D90909074
        75747475749090908D8D8D9090907172717C847CBFDABFC0DCC0C0DCC0C0DCC0
        BDD9C0464EB62F30BB5959D65252D45B5BD75B5BD75353D45959D62F30BB464E
        B6BDD9C0C0DCC0C0DCC0C0DCC0C0DCC0BFDABF7E867E75767597979793939399
        99999999999393939797977576757E867EBFDABFC0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0BDD9C04850B73638C06565DB6363DB6363DB6565DB3638C04850B7BDD9
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BFDABF8088807B7D7BA0A0A09F
        9F9F9F9F9FA0A0A07B7D7B808880BFDABFC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0BDD9C04B53B93C3EC46E6EDF6A6ADF6A6ADF6E6EDF3D3FC44B53B9BDD9
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BFDABF828A82808180A7A7A7A5
        A5A5A5A5A5A7A7A7818281828A82BFDABFC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        BDD9C04D55BB3D3EC57676E36A6AE17777E47777E46969E17676E33D3EC54D55
        BBBDD9C0C0DCC0C0DCC0C0DCC0C0DCC0BFDABF848C84828382ADADADA6A6A6AE
        AEAEAEAEAEA5A5A5ADADAD828382848C84BFDABFC0DCC0C0DCC0C0DCC0BDD9C0
        5058BC4041C77E7EE67171E47F7FE64547C94547C97F7FE67272E47E7EE64142
        C85058BCBDD9C0C0DCC0C0DCC0BFDABF868E86838483B2B2B2ABABABB3B3B387
        8887878887B3B3B3ABABABB2B2B2848684868E86BFDABFC0DCC0C0DCC05962BE
        4647C98686E77878E58888E74748C9535BBD535BBD4748C98888E77979E58787
        E74647C95962BEC0DCC0C0DCC08B958B878887B7B7B7AFAFAFB8B8B888898888
        9088889088888988B8B8B8AFAFAFB7B7B78788878B958BC0DCC0C0DCC05B65BF
        4C4DCB8F8FE99090E94D4ECB555DC0BEDAC0BEDAC0555DC04D4ECB9090E98F8F
        E94C4DCB5B65BFC0DCC0C0DCC08D978D8B8C8BBCBCBCBDBDBD8C8D8C8B938BBF
        DBBFBFDBBF8B938B8C8D8CBDBDBDBCBCBC8B8C8B8D978DC0DCC0C0DCC0BEDAC0
        575FC05051CC5152CC575FC0BEDAC0C0DCC0C0DCC0BEDAC05860C05253CD5253
        CC5860C0BEDAC0C0DCC0C0DCC0BFDBBF8C948C8E8F8E8E8F8E8C948CBFDBBFC0
        DCC0C0DCC0BFDBBF8C948C8F908F8F908F8C948CBFDBBFC0DCC0C0DCC0C0DCC0
        BEDAC05F69C26069C2BEDAC0C0DCC0C0DCC0C0DCC0C0DCC0BEDAC06069C26069
        C2BEDAC0C0DCC0C0DCC0C0DCC0C0DCC0BFDBBF919A91919A91BFDBBFC0DCC0C0
        DCC0C0DCC0C0DCC0BFDBBF919A91919A91BFDBBFC0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0}
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 1
    end
    object OKBtn: TBitBtn
      Left = 375
      Top = 30
      Width = 61
      Height = 31
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0AFCEAC3C70263D7127B6D4B4C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0B6CFB670757070
        7670BAD4BAC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC09EC0982B6212347715316F13669257C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0ABC1AB6567657171716D
        6E6D899589C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC087AD7D285F0D3E851B479521469121275E0CAECDABC0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC09DAF9D6364637A7A7A83838381
        8181626362B5CEB5C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BFDBBF
        6894592C6510499622499921418D1B499B213B7E1B578644C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0BFDBBF8A978A6768678484848484847D7D7D85
        8585767776808980C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0B9D6B74C7D37
        336F1650A8244A9C214CA12252AF2547961F51AB2529610EA3C49EC0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0BCD6BC7980796D6E6D8B8B8B8585858888888E8E8E82
        82828D8D8D656665AFC6AFC0DCC0C0DCC0C0DCC0C0DCC0C0DCC050803C3C7F1C
        56B6264BA12153B1254D9F254B992550AB234FA923468F23487A33C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC07C847C7778779292928787878F8F8F8888888686868C
        8C8C8B8B8B818181777D77C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0396E214E9F26
        56BA255AC227488F242E651429610D59BD284BA2205BC2282F691397BA90C0DC
        C0C0DCC0C0DCC0C0DCC06E726E888888939393979797818181676A6765666596
        96968787879797976A6B6AA7BCA7C0DCC0C0DCC0C0DCC0C0DCC0A2C39D2A610F
        57B7293F811F42752CB2D1B05F8D4E468B2358BF2653B52352A9273B6F23C0DC
        C0C0DCC0C0DCC0C0DCC0AEC5AE656665939393797A79747974B8D1B88590857F
        7F7F9696969090908D8D8D6F736FC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08AAF81
        316717629052BEDABDC0DCC0B2D1B029600E60CC2A50B02162D62938761A89AE
        7FC0DCC0C0DCC0C0DCC0C0DCC09FB29F696C69879387BFDABFC0DCC0B8D1B864
        65649C9C9C8D8D8DA0A0A07273729EB19EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC06F9961468A2461D82756BF235DC42A3066
        16BCD9BCC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC08F
        9C8F7E7F7EA0A0A0949494999999686A68BED9BEC0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0B9D7B82C631162D22B56BF2268DA304284
        217AA26EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BC
        D7BC666866A0A0A0949494A5A5A57B7C7B95A595C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC080A7744182216ADC3258C62164D5
        2D2A610FB7D5B6C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC099A999797A79A6A6A6969696A1A1A1656665BBD5BBC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BEDBBE346A1B5FC92B59C92267DB
        2E4990276B965CC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0BFDBBF6B6F6B9B9B9B989898A4A4A48283828C998CC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC08FB4873A771C6DDC3662D9
        2865D42E326919C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0A2B6A2737573A8A8A8A0A0A0A1A1A16A6D6AC0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC041752A57B52955B0
        282D6712729D64C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0737973929292909090696A69919F91C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0A1C39C306716487A
        32A3C49EC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0ADC4AD696B69777E77AFC6AFC0DCC0C0DCC0}
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 0
    end
    object paTab: TPanel
      Left = 195
      Top = 13
      Width = 76
      Height = 53
      BevelOuter = bvNone
      TabOrder = 3
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 48
        Height = 13
        Caption = 'Tabwidth:'
      end
      object edTab: TEdit
        Left = 10
        Top = 25
        Width = 41
        Height = 21
        TabOrder = 0
        Text = '12'
        OnChange = edTabChange
      end
      object udTab: TUpDown
        Left = 51
        Top = 25
        Width = 16
        Height = 21
        Associate = edTab
        Min = 5
        Position = 12
        TabOrder = 1
      end
    end
    object cxRange: TCheckBox
      Left = 375
      Top = 5
      Width = 151
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Align ranges'
      TabOrder = 4
    end
  end
  object paData: TPanel
    Left = 0
    Top = 51
    Width = 546
    Height = 249
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      546
      249)
    object seHeader: TSynEdit
      Left = 10
      Top = 5
      Width = 526
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 1
      TabStop = False
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.LeftOffset = 20
      Gutter.RightOffset = 5
      Gutter.Width = 35
      Gutter.Gradient = True
      Lines.Strings = (
        '')
      ReadOnly = True
      ScrollBars = ssNone
      FontSmoothing = fsmNone
    end
    object seData: TSynEdit
      Left = 10
      Top = 25
      Width = 526
      Height = 216
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 0
      OnKeyDown = seDataKeyDown
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.LeftOffset = 0
      Gutter.RightOffset = 5
      Gutter.ShowLineNumbers = True
      Gutter.Width = 20
      Gutter.Gradient = True
      Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs]
      ScrollBars = ssVertical
      SearchEngine = SynEditSearch
      WantTabs = True
      OnChange = seDataChange
      FontSmoothing = fsmNone
    end
  end
  object OpenDialog: TOpenDialog
    Left = 415
    Top = 160
  end
  object SynEditSearch: TSynEditSearch
    Left = 345
    Top = 165
  end
end
