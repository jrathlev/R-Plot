object CurveDialog: TCurveDialog
  Left = 227
  Top = 108
  ActiveControl = edDescription
  BorderStyle = bsDialog
  Caption = 'Properties of data curve'
  ClientHeight = 374
  ClientWidth = 516
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    516
    374)
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TBitBtn
    Left = 342
    Top = 335
    Width = 61
    Height = 31
    Anchors = [akRight, akBottom]
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
  object CancelBtn: TBitBtn
    Left = 412
    Top = 335
    Width = 96
    Height = 31
    Anchors = [akRight, akBottom]
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
  object gbXAxis: TGroupBox
    Left = 10
    Top = 50
    Width = 251
    Height = 76
    Caption = 'Select X axis'
    TabOrder = 3
    object cbXAxisSelect: TComboBox
      Left = 13
      Top = 20
      Width = 231
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnCloseUp = cbXAxisSelectCloseUp
    end
    object cxXRange: TCheckBox
      Left = 30
      Top = 50
      Width = 151
      Height = 17
      Caption = 'Align range'
      TabOrder = 1
    end
  end
  object gbYAxis: TGroupBox
    Left = 10
    Top = 135
    Width = 251
    Height = 76
    Caption = 'Select Y axis'
    TabOrder = 4
    object cbYAxisSelect: TComboBox
      Left = 13
      Top = 20
      Width = 231
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object cxYRange: TCheckBox
      Left = 30
      Top = 50
      Width = 151
      Height = 17
      Caption = 'Align range'
      TabOrder = 1
    end
  end
  object gbMarker: TGroupBox
    Left = 10
    Top = 220
    Width = 251
    Height = 106
    Caption = 'Symbol'
    TabOrder = 5
    object sbDot: TSpeedButton
      Left = 15
      Top = 20
      Width = 26
      Height = 26
      GroupIndex = 1
      Down = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBB0000BBBBBBBBBB00000000BBBBBBB000000000
        0BBBBBB0000000000BBBBB000000000000BBBB000000000000BBBB0000000000
        00BBBB000000000000BBBBB0000000000BBBBBB0000000000BBBBBBB00000000
        BBBBBBBBBB0000BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbDiamond: TSpeedButton
      Left = 40
      Top = 20
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBB00BBBBBBBBBBBBB0000BBBBBBBBBBB000000BBBBBBBBB00000000
        BBBBBBB0000000000BBBBB000000000000BBB00000000000000BB00000000000
        000BBB000000000000BBBBB0000000000BBBBBBB00000000BBBBBBBBB000000B
        BBBBBBBBBB0000BBBBBBBBBBBBB00BBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbTriangle: TSpeedButton
      Left = 65
      Top = 20
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBB000000000000BBBB000000000000BBBB0000000000
        00BBBB000000000000BBBBB0000000000BBBBBB0000000000BBBBBBB00000000
        BBBBBBBB00000000BBBBBBBBB000000BBBBBBBBBB000000BBBBBBBBBBB0000BB
        BBBBBBBBBB0000BBBBBBBBBBBBB00BBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbSquare: TSpeedButton
      Left = 90
      Top = 20
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBB000000000000BBBB000000000000BBBB0000000000
        00BBBB000000000000BBBB000000000000BBBB000000000000BBBB0000000000
        00BBBB000000000000BBBB000000000000BBBB000000000000BBBB0000000000
        00BBBB000000000000BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbDelta: TSpeedButton
      Left = 115
      Top = 20
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBB00BBBBBBBBBBBBB0000BBBBBBBBBBBB0000BBBBBBBBBBB000000B
        BBBBBBBBB000000BBBBBBBBB00000000BBBBBBBB00000000BBBBBBB000000000
        0BBBBBB0000000000BBBBB000000000000BBBB000000000000BBBB0000000000
        00BBBB000000000000BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbNoSym: TSpeedButton
      Left = 65
      Top = 70
      Width = 76
      Height = 26
      GroupIndex = 1
      Caption = 'No symbol'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Update
    end
    object laSymbolColor: TLabel
      Left = 150
      Top = 58
      Width = 29
      Height = 13
      Caption = 'Color:'
    end
    object laSymbolSize: TLabel
      Left = 150
      Top = 28
      Width = 23
      Height = 13
      Caption = 'Size:'
    end
    object laSymbolUnit: TLabel
      Tag = 1
      Left = 205
      Top = 32
      Width = 13
      Height = 13
      Caption = 'cm'
    end
    object sbCircle: TSpeedButton
      Left = 15
      Top = 45
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBB0000BBBBBBBBBB00000000BBBBBBB000BBBB00
        0BBBBBB00BBBBBB00BBBBB00BBBBBBBB00BBBB00BBBBBBBB00BBBB00BBBBBBBB
        00BBBB00BBBBBBBB00BBBBB00BBBBBB00BBBBBB000BBBB000BBBBBBB00000000
        BBBBBBBBBB0000BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbODiamond: TSpeedButton
      Left = 40
      Top = 45
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBB00BBBBBBBBBBBBB0000BBBBBBBBBBB000000BBBBBBBBB000BB000
        BBBBBBB000BBBB000BBBBB000BBBBBB000BBB000BBBBBBBB000BB000BBBBBBBB
        000BBB000BBBBBB000BBBBB000BBBB000BBBBBBB000BB000BBBBBBBBB000000B
        BBBBBBBBBB0000BBBBBBBBBBBBB00BBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbOTriangle: TSpeedButton
      Left = 65
      Top = 45
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFF00000000000000FF00000000000000FF00FFFFFFFFFF00FFF00FFFFFFFF
        00FFFF00FFFFFFFF00FFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFFF00FFFF00
        FFFFFFFF00FFFF00FFFFFFFFF00FF00FFFFFFFFFF00FF00FFFFFFFFFFF0000FF
        FFFFFFFFFFF00FFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFF}
      OnClick = Update
    end
    object sbOSquare: TSpeedButton
      Left = 90
      Top = 45
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBBBBBBBBBBB000000000000BBBB000000000000BBBB00BBBBBBBB
        00BBBB00BBBBBBBB00BBBB00BBBBBBBB00BBBB00BBBBBBBB00BBBB00BBBBBBBB
        00BBBB00BBBBBBBB00BBBB00BBBBBBBB00BBBB00BBBBBBBB00BBBB0000000000
        00BBBB000000000000BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbODelta: TSpeedButton
      Left = 115
      Top = 45
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBB00BBBBBBBBBBBBB0000BBBBBBBBBBBB0000BBBBBBBBBBB00BB00B
        BBBBBBBBB00BB00BBBBBBBBB00BBBB00BBBBBBBB00BBBB00BBBBBBB00BBBBBB0
        0BBBBBB00BBBBBB00BBBBB00BBBBBBBB00BBBB00BBBBBBBB00BBBB0000000000
        00BBBB000000000000BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbPlus: TSpeedButton
      Left = 15
      Top = 70
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBB00BBBBBBBBBBBBBB00BBBBBBBBBBBBBB00BBBBBBBBBBBBBB00BBB
        BBBBBBBBBBB00BBBBBBBBBBBBBB00BBBBBBBB00000000000000BB00000000000
        000BBBBBBBB00BBBBBBBBBBBBBB00BBBBBBBBBBBBBB00BBBBBBBBBBBBBB00BBB
        BBBBBBBBBBB00BBBBBBBBBBBBBB00BBBBBBBBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object sbCross: TSpeedButton
      Left = 40
      Top = 70
      Width = 26
      Height = 26
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBB00BBBBBBBBBB00BB000BBBBBBBB000BBB000BBBBBB000BBBBB000BBBB00
        0BBBBBBB000BB000BBBBBBBBB000000BBBBBBBBBBB0000BBBBBBBBBBBB0000BB
        BBBBBBBBB000000BBBBBBBBB000BB000BBBBBBB000BBBB000BBBBB000BBBBBB0
        00BBB000BBBBBBBB000BB00BBBBBBBBBB00BBBBBBBBBBBBBBBBB}
      OnClick = Update
    end
    object edSymbolSize: TFloatRangeEdit
      Tag = 3
      Left = 150
      Top = 30
      Width = 46
      Height = 21
      Alignment = taRightJustify
      TabOrder = 0
      Digits = 4
      Decimal = 1
      StepMultiplier = 1.000000000000000000
      Value = 0.300000000000000000
      MinValue = 0.020000000000000000
      MaxValue = 10.000000000000000000
    end
    object bbSymBolColor: TBitBtn
      Left = 150
      Top = 75
      Width = 86
      Height = 21
      TabOrder = 1
      OnClick = bbSymBolColorClick
    end
  end
  object gbConn: TGroupBox
    Left = 270
    Top = 50
    Width = 236
    Height = 161
    Caption = 'Connect points'
    TabOrder = 7
    object Label5: TLabel
      Left = 70
      Top = 38
      Width = 13
      Height = 13
      Caption = 'cm'
    end
    object Label6: TLabel
      Left = 15
      Top = 20
      Width = 52
      Height = 13
      Caption = 'Line width:'
    end
    object laSmooth: TLabel
      Left = 160
      Top = 110
      Width = 54
      Height = 13
      Caption = 'Smoothing:'
    end
    object Label2: TLabel
      Left = 109
      Top = 63
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Color:'
    end
    object Label1: TLabel
      Left = 110
      Top = 39
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Style:'
    end
    object edLineWidth: TFloatRangeEdit
      Left = 15
      Top = 35
      Width = 46
      Height = 21
      Alignment = taRightJustify
      TabOrder = 0
      Digits = 4
      StepMultiplier = 1.000000000000000000
      Value = 0.050000000000000000
      MinValue = 0.100000000000000000
      MaxValue = 10.000000000000000000
    end
    object rbConnect: TRadioButton
      Left = 15
      Top = 105
      Width = 136
      Height = 17
      Caption = 'Linear connections'
      TabOrder = 4
      OnClick = rbConnectClick
    end
    object rbSpline: TRadioButton
      Left = 15
      Top = 125
      Width = 136
      Height = 17
      Caption = 'Spline function'
      TabOrder = 5
      OnClick = rbSplineClick
    end
    object rbNoLine: TRadioButton
      Left = 15
      Top = 85
      Width = 136
      Height = 17
      Caption = 'No connections'
      Checked = True
      TabOrder = 3
      TabStop = True
      OnClick = rbNoLineClick
    end
    object cxStyle: TComboBox
      Left = 145
      Top = 35
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Solid'
      Items.Strings = (
        'Solid'
        'Dashed'
        'Dotted')
    end
    object bbLineColor: TBitBtn
      Left = 145
      Top = 60
      Width = 81
      Height = 21
      TabOrder = 2
      OnClick = bbLineColorClick
    end
    object reSmooth: TRangeEdit
      Left = 160
      Top = 125
      Width = 36
      Height = 21
      TabOrder = 6
      OnChange = reSmoothChange
      Value = 0
      MinValue = 0
      MaxValue = 100
    end
    object udSmooth: TNumUpDown
      Left = 196
      Top = 125
      Width = 16
      Height = 21
      Associate = reSmooth
      TabOrder = 7
    end
  end
  object edDescription: TLabeledEdit
    Left = 10
    Top = 20
    Width = 251
    Height = 21
    EditLabel.Width = 74
    EditLabel.Height = 13
    EditLabel.Caption = 'Name of curve:'
    TabOrder = 2
  end
  object bbData: TBitBtn
    Left = 270
    Top = 10
    Width = 241
    Height = 31
    Caption = 'Edit data'
    TabOrder = 6
    OnClick = bbDataClick
  end
  object gbErrBars: TGroupBox
    Left = 270
    Top = 220
    Width = 236
    Height = 106
    Caption = 'Show error bars'
    TabOrder = 8
    object Label8: TLabel
      Left = 15
      Top = 55
      Width = 52
      Height = 13
      Caption = 'Line width:'
    end
    object Label9: TLabel
      Tag = 1
      Left = 70
      Top = 73
      Width = 13
      Height = 13
      Caption = 'cm'
    end
    object Label3: TLabel
      Left = 115
      Top = 53
      Width = 29
      Height = 13
      Caption = 'Color:'
    end
    object edErrorWidth: TFloatRangeEdit
      Left = 15
      Top = 70
      Width = 46
      Height = 21
      Alignment = taRightJustify
      TabOrder = 2
      Digits = 4
      StepMultiplier = 1.000000000000000000
      Value = 0.050000000000000000
      MinValue = 0.100000000000000000
      MaxValue = 10.000000000000000000
    end
    object cbXErr: TCheckBox
      Left = 15
      Top = 22
      Width = 97
      Height = 17
      Caption = 'X error bars'
      TabOrder = 0
    end
    object cbYErr: TCheckBox
      Left = 118
      Top = 22
      Width = 97
      Height = 17
      Caption = 'Y error bars'
      TabOrder = 1
    end
    object bbErrColor: TBitBtn
      Left = 115
      Top = 70
      Width = 86
      Height = 21
      TabOrder = 3
      OnClick = bbErrColorClick
    end
  end
  object cbShow: TCheckBox
    Left = 15
    Top = 343
    Width = 101
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Visible'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object bbLoadTemplate: TBitBtn
    Left = 266
    Top = 335
    Width = 31
    Height = 31
    Hint = 'Load settings from template'
    Anchors = [akRight, akBottom]
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
      C0DCC0A56B3CA06638A46534A46534A46534A06638A46534A46534A46534A465
      34A06638A5A19EC0DCC0C0DCC0C0DCC0C0DCC09C9C9C97979797979797979797
      9797979797979797979797979797979797979797CCCCCCC0DCC0C0DCC0C0DCC0
      AE825C9E8C6D00C1E900C1E900C1E900C1E900C1E900C1E900C1E900C1E900BA
      E19F6A40007B94C0DCC0C0DCC0C0DCC0B0B0B0B0B0B0A0A0A0A0A0A0A0A0A0A0
      A0A0A0A0A0A0A0A0A0A0A0A0A0A09C9C9C9B9B9B757575C0DCC0C0DCC0E5D3C6
      A68B6700C1E900C1E900C1E900C1E900C1E900C1E900C1E900C1E900C1E99B82
      61605D5D605D5D605D5DC0DCC0FDFDFDB0B0B0A0A0A0A0A0A0A0A0A0A0A0A0A0
      A0A0A0A0A0A0A0A0A0A0A0A0A0A0A9A9A98C88888C88888C8888C0DCC0BE9878
      97B6A500C1E900C1E900C1E900C1E900C1E900C1E900C1E900C1E900B9E09F6A
      40FFFFFFFFFFFF605D5DC0DCC0C5C5C5D1D1D1A0A0A0A0A0A0A0A0A0A0A0A0A0
      A0A0A0A0A0A0A0A0A0A0A09B9B9B9B9B9BFFFFFFFFFFFF8C8888E8D8CCA38462
      00C1E900C1E900C1E900C1E900C7F100CCF700CCF700CCF700CBF69E8C6D605D
      5D605D5DFFFFFF605D5DFFFFFFACACACA0A0A0A0A0A0A0A0A0A0A0A0A4A4A4A7
      A7A7A7A7A7A7A7A7A5A5A5B0B0B08C88888C8888FFFFFF8C8888CBA98D9BA993
      00C1E900C1E900C1E900C7F100CBF600CBF600CBF600CBF600CBF6A27248FFFF
      FFFFFFFFFFFFFF605D5DD5D5D5C7C7C7A0A0A0A0A0A0A0A0A0A4A4A4A5A5A5A5
      A5A5A5A5A5A5A5A5A5A5A5A0A0A0FFFFFFFFFFFFFFFFFF8C8888B0805800B6DC
      00C1E900C1E900C7F100C7F100C7F100C7F100C7F100C7F100BAE1A56E41605D
      5D605D5DFFFFFF605D5DAFAFAF999999A0A0A0A0A0A0A4A4A4A4A4A4A4A4A4A4
      A4A4A4A4A4A4A4A49C9C9C9E9E9E8C88888C8888FFFFFF8C8888A78E6D00C1E9
      00C1E900C1E900C1E900C1E900C1E900C1E900C1E900C7F19BA993A2947BFFFF
      FFFFFFFFFFFFFF605D5DB5B5B5A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0
      A0A0A0A0A0A4A4A4C7C7C7B8B8B8FFFFFFFFFFFFFFFFFF8C8888A46534A46534
      A46534A46534A46534A46534A46534A46534A46534A46534A56B3CA7B3AA605D
      5D605D5DFFFFFF605D5D97979797979797979797979797979797979797979797
      97979797979797979C9C9CD7D7D78C88888C8888FFFFFF8C8888C0DCC0C0DCC0
      EDEDED00475600C1E9605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFF605D5DC0DCC0C0DCC0FFFFFF575757A0A0A08C8888FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8888C0DCC0C0DCC0
      C0DCC00047560096B5605D5DFFFFFF605D5D605D5D605D5D605D5D605D5D605D
      5D605D5DFFFFFF605D5DC0DCC0C0DCC0C0DCC05757578686868C8888FFFFFF8C
      88888C88888C88888C88888C88888C88888C8888FFFFFF8C8888C0DCC0C0DCC0
      C0DCC0007E98828282605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFF605D5DC0DCC0C0DCC0C0DCC0787878ACACAC8C8888FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8888C0DCC0C0DCC0
      C0DCC0C0DCC0C0DCC0605D5DFFFFFF605D5D605D5D605D5D605D5D605D5D605D
      5D605D5DFFFFFF605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFF8C
      88888C88888C88888C88888C88888C88888C8888FFFFFF8C8888C0DCC0C0DCC0
      C0DCC0C0DCC0C0DCC0605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFF605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8888C0DCC0C0DCC0
      C0DCC0C0DCC0C0DCC0605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFF605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8888C0DCC0C0DCC0
      C0DCC0C0DCC0C0DCC0605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D
      5D605D5D605D5D605D5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C88888C88888C
      88888C88888C88888C88888C88888C88888C88888C88888C8888}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = bbLoadTemplateClick
  end
  object bbSaveTemplate: TBitBtn
    Left = 301
    Top = 335
    Width = 31
    Height = 31
    Hint = 'Save settings as template'
    Anchors = [akRight, akBottom]
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      18000000000000060000120B0000120B00000000000000000000C0DCC0773102
      7731023C403E3C403E3C403E3C403E3C403E3C403E3C403E3C403E3C403E7731
      027731027731027731027731023D3D3D3D3D3D3E3E3E3E3E3E3E3E3E3E3E3E3E
      3E3E3E3E3E3E3E3E3E3E3E3E3E3E3D3D3D3D3D3D3D3D3D3D3D3D773102773102
      C59D7E83694EDFDFDFD0D0D0B0B0B0B0B0B0B0B0B0AFAFAFAFAFAF856A4EC792
      5FD7AE8AE7CCB57731023D3D3D3D3D3DA2A2A2696969DFDFDFD0D0D0B0B0B0B0
      B0B0B0B0B0AFAFAFAFAFAF6A6A6A939393B1B1B1CECECE3D3D3D773102C59D7E
      D7AE8A83694DDDDDDDE2E2E23C403E3C403EBDBDBDB9B9B9A7A7A784684BC791
      5ED6AC85E7CCB57731023D3D3DA2A2A2B1B1B1686868DDDDDDE2E2E23E3E3E3E
      3E3EBDBDBDB9B9B9A7A7A7686868929292AEAEAECECECE3D3D3D773102E7CCB5
      C8925F83694DBDBDBDDDDDDD3C403E3C403EBDBDBDBDBDBDB6B6B684684BC791
      5ED6AC85E7CCB57731023D3D3DCECECE939393686868BDBDBDDDDDDD3E3E3E3E
      3E3EBDBDBDBDBDBDB6B6B6686868929292AEAEAECECECE3D3D3D773102E7CCB5
      C8925F83684BBDBDBDBDBDBD3C403E3C403EDEDEDEBDBDBDAFAFAF84684BC791
      5ED6AC85E7CCB57731023D3D3DCECECE939393676767BDBDBDBDBDBD3E3E3E3E
      3E3EDEDEDEBDBDBDAFAFAF686868929292AEAEAECECECE3D3D3D773102E7CCB5
      C8925F8E6C4AB0B0B0BDBDBDBDBDBDDDDDDDE3E3E3D1D1D1B0B0AF8B6947C791
      5CD6AC85E7CCB57731023D3D3DCECECE9393936C6C6CB0B0B0BDBDBDBDBDBDDD
      DDDDE3E3E3D1D1D1B0B0B0696969919191AEAEAECECECE3D3D3D773102E7CCB5
      C8925FA57C55856A4D856A4D856A4D856A4D856A4D856A4D856A4DA57C55D6AC
      85C8925FE7CCB57731023D3D3DCECECE9393937D7D7D69696969696969696969
      69696969696969696969697D7D7DAEAEAE939393CECECE3D3D3D773102E7CCB5
      C8925FC8925FC8925FC8925FC8925FC8925FC8925FC8925FC8925FC8925FC892
      5FC8925FE7CCB57731023D3D3DCECECE93939393939393939393939393939393
      9393939393939393939393939393939393939393CECECE3D3D3D773102E7CCB5
      C8925FFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD
      FDC8925FE7CCB57731023D3D3DCECECE939393FDFDFDFDFDFDFDFDFDFDFDFDFD
      FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD939393CECECE3D3D3D773102E7CCB5
      C8925FFDFDFDF2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2
      F2C8925FE7CCB57731023D3D3DCECECE939393FDFDFDF2F2F2F2F2F2F2F2F2F2
      F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2939393CECECE3D3D3D773102E7CCB5
      C8925FFDFDFDD1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1F2F2
      F2C8925FE7CCB57731023D3D3DCECECE939393FDFDFDD1D1D1D1D1D1D1D1D1D1
      D1D1D1D1D1D1D1D1D1D1D1D1D1D1F2F2F2939393CECECE3D3D3D773102E7CCB5
      C8925FFDFDFDF2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2
      F2C8925FE7CCB57731023D3D3DCECECE939393FDFDFDF2F2F2F2F2F2F2F2F2F2
      F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2939393CECECE3D3D3D773102E7CCB5
      C8925FF8F8F8DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEF8F8
      F8C8925FE7CCB57731023D3D3DCECECE939393F8F8F8DEDEDEDEDEDEDEDEDEDE
      DEDEDEDEDEDEDEDEDEDEDEDEDEDEF8F8F8939393CECECE3D3D3D773102E7CCB5
      C8925FF8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
      F8C8925FE7CCB57731023D3D3DCECECE939393F8F8F8F8F8F8F8F8F8F8F8F8F8
      F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8939393CECECE3D3D3D773102E7CCB5
      EBD3C024A4FB24A4FB24A4FB24A4FB24A4FB24A4FB24A4FB24A4FB24A4FB24A4
      FBE7CCB5E7CCB57731023D3D3DCECECED5D5D58F8F8F8F8F8F8F8F8F8F8F8F8F
      8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8FCECECECECECE3D3D3D773102773102
      7731020046C70046C70046C70046C70046C70046C70046C70046C70046C70046
      C77731027731027731023D3D3D3D3D3D3D3D3D64646464646464646464646464
      64646464646464646464646464646464643D3D3D3D3D3D3D3D3D}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = bbSaveTemplateClick
  end
  object ColorDialog: TColorDialog
    Left = 163
    Top = 5
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 195
    Top = 5
  end
  object SaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 230
    Top = 5
  end
end
