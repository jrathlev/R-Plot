object ImportDialog: TImportDialog
  Left = 319
  Top = 226
  BorderStyle = bsDialog
  Caption = 'Import csv data'
  ClientHeight = 422
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    594
    422)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 75
    Top = 393
    Width = 108
    Height = 13
    Alignment = taRightJustify
    Caption = 'Reduce data by factor'
  end
  object OKBtn: TBitBtn
    Left = 408
    Top = 385
    Width = 71
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
    Left = 488
    Top = 385
    Width = 101
    Height = 31
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
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
    ParentFont = False
    TabOrder = 1
  end
  object rgDecimal: TRadioGroup
    Left = 400
    Top = 30
    Width = 186
    Height = 76
    Caption = 'Decimal separator'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Point'
      'Comma')
    TabOrder = 3
    OnClick = rgDecimalClick
  end
  object gbColumns: TGroupBox
    Left = 5
    Top = 170
    Width = 581
    Height = 86
    Caption = 'Columns'
    TabOrder = 6
    object Label1: TLabel
      Tag = 1
      Left = 10
      Top = 23
      Width = 10
      Height = 13
      Alignment = taRightJustify
      Caption = 'X:'
    end
    object laXM: TLabel
      Tag = 3
      Left = 174
      Top = 23
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = '-X-Err.:'
    end
    object laXP: TLabel
      Tag = 2
      Left = 76
      Top = 23
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = '+X-Err.:'
    end
    object Label6: TLabel
      Tag = 4
      Left = 295
      Top = 23
      Width = 10
      Height = 13
      Alignment = taRightJustify
      Caption = 'Y:'
    end
    object siX: TSpotIndicator
      Tag = 1
      Left = 7
      Top = 53
      Width = 16
      Height = 16
      ColorOff = clGreen
    end
    object siXP: TSpotIndicator
      Tag = 2
      Left = 102
      Top = 53
      Width = 16
      Height = 16
      ColorOff = clGreen
    end
    object siXM: TSpotIndicator
      Tag = 3
      Left = 197
      Top = 53
      Width = 16
      Height = 16
      ColorOff = clGreen
    end
    object siY: TSpotIndicator
      Tag = 4
      Left = 292
      Top = 53
      Width = 16
      Height = 16
      ColorOff = clGreen
    end
    object laYM: TLabel
      Tag = 6
      Left = 459
      Top = 23
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = '-Y-Err.:'
    end
    object laYP: TLabel
      Tag = 5
      Left = 360
      Top = 23
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = '+Y-Err.:'
    end
    object siYP: TSpotIndicator
      Tag = 5
      Left = 387
      Top = 53
      Width = 16
      Height = 16
      ColorOff = clGreen
    end
    object siYM: TSpotIndicator
      Tag = 6
      Left = 482
      Top = 53
      Width = 16
      Height = 16
      ColorOff = clGreen
    end
    object edX: TEdit
      Tag = 1
      Left = 25
      Top = 50
      Width = 71
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 0
    end
    object edXM: TEdit
      Tag = 3
      Left = 215
      Top = 50
      Width = 71
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 2
    end
    object edXP: TEdit
      Tag = 2
      Left = 120
      Top = 50
      Width = 71
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 1
    end
    object edY: TEdit
      Tag = 4
      Left = 310
      Top = 50
      Width = 71
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 3
    end
    object edYP: TEdit
      Tag = 5
      Left = 405
      Top = 50
      Width = 71
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 5
    end
    object edYM: TEdit
      Tag = 6
      Left = 500
      Top = 50
      Width = 71
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 4
    end
    object reXCol: TRangeEdit
      Tag = 1
      Left = 25
      Top = 20
      Width = 31
      Height = 21
      TabOrder = 6
      OnChange = SettingsChange
      Value = 1
      MinValue = 1
      MaxValue = 99
    end
    object udXCol: TNumUpDown
      Tag = 1
      Left = 56
      Top = 20
      Width = 16
      Height = 21
      Associate = reXCol
      TabOrder = 7
    end
    object reXPCol: TRangeEdit
      Tag = 2
      Left = 120
      Top = 20
      Width = 31
      Height = 21
      TabOrder = 8
      OnChange = SettingsChange
      Value = 2
      MinValue = 1
      MaxValue = 99
    end
    object udXPCol: TNumUpDown
      Tag = 2
      Left = 151
      Top = 20
      Width = 16
      Height = 21
      Associate = reXPCol
      TabOrder = 9
    end
    object reXMCol: TRangeEdit
      Tag = 3
      Left = 215
      Top = 20
      Width = 31
      Height = 21
      TabOrder = 10
      OnChange = SettingsChange
      Value = 3
      MinValue = 1
      MaxValue = 99
    end
    object udXMCol: TNumUpDown
      Tag = 3
      Left = 246
      Top = 20
      Width = 16
      Height = 21
      Associate = reXMCol
      TabOrder = 11
    end
    object reYCol: TRangeEdit
      Tag = 4
      Left = 310
      Top = 20
      Width = 31
      Height = 21
      TabOrder = 12
      OnChange = SettingsChange
      Value = 4
      MinValue = 1
      MaxValue = 99
    end
    object udYCol: TNumUpDown
      Tag = 4
      Left = 341
      Top = 20
      Width = 16
      Height = 21
      Associate = reYCol
      TabOrder = 13
    end
    object reYPCol: TRangeEdit
      Tag = 5
      Left = 405
      Top = 20
      Width = 31
      Height = 21
      TabOrder = 14
      OnChange = SettingsChange
      Value = 5
      MinValue = 1
      MaxValue = 99
    end
    object udYPCol: TNumUpDown
      Tag = 5
      Left = 436
      Top = 20
      Width = 16
      Height = 21
      Associate = reYPCol
      TabOrder = 15
    end
    object reYMCol: TRangeEdit
      Tag = 6
      Left = 500
      Top = 20
      Width = 31
      Height = 21
      TabOrder = 16
      OnChange = SettingsChange
      Value = 6
      MinValue = 1
      MaxValue = 99
    end
    object udYMCol: TNumUpDown
      Tag = 6
      Left = 531
      Top = 20
      Width = 16
      Height = 21
      Associate = reYMCol
      TabOrder = 17
    end
  end
  object gbLine: TGroupBox
    Left = 400
    Top = 110
    Width = 186
    Height = 51
    Caption = 'Read data from'
    TabOrder = 5
    object Label4: TLabel
      Left = 10
      Top = 23
      Width = 44
      Height = 13
      Caption = 'First line:'
    end
    object reLine: TRangeEdit
      Left = 85
      Top = 20
      Width = 51
      Height = 21
      TabOrder = 0
      OnChange = SettingsChange
      Alignment = taRightJustify
      Value = 1
      MinValue = 1
      MaxValue = 99999
    end
    object udLine: TNumUpDown
      Left = 136
      Top = 20
      Width = 16
      Height = 21
      Associate = reLine
      TabOrder = 1
    end
  end
  object paPreview: TPanel
    Left = 5
    Top = 260
    Width = 581
    Height = 116
    BevelOuter = bvNone
    TabOrder = 7
    object Label3: TLabel
      Left = 10
      Top = 5
      Width = 90
      Height = 13
      Caption = 'Data of import file:'
    end
    object laLines: TLabel
      Left = 10
      Top = 95
      Width = 3
      Height = 13
    end
    object mePreview: TMemo
      Left = 10
      Top = 20
      Width = 561
      Height = 71
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
  end
  object gbQuote: TGroupBox
    Left = 5
    Top = 110
    Width = 391
    Height = 51
    Caption = 'Quote character'
    TabOrder = 4
    object rbNoQuote: TRadioButton
      Left = 10
      Top = 20
      Width = 86
      Height = 17
      Caption = 'None'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbNoQuoteClick
    end
    object rbQuote: TRadioButton
      Left = 110
      Top = 20
      Width = 106
      Height = 17
      Caption = 'Double quote'
      TabOrder = 1
      OnClick = rbQuoteClick
    end
    object rbOtherQuote: TRadioButton
      Left = 220
      Top = 20
      Width = 76
      Height = 17
      Caption = 'Other'
      TabOrder = 2
      OnClick = rbOtherQuoteClick
    end
    object edQuote: TEdit
      Left = 310
      Top = 17
      Width = 46
      Height = 21
      TabOrder = 3
    end
  end
  object gbDelim: TGroupBox
    Left = 5
    Top = 30
    Width = 391
    Height = 76
    Caption = 'Column separator'
    TabOrder = 2
    object rbSpace: TRadioButton
      Left = 10
      Top = 45
      Width = 91
      Height = 17
      Caption = 'Space'
      TabOrder = 3
      OnClick = rbSpaceClick
    end
    object rbTab: TRadioButton
      Left = 10
      Top = 20
      Width = 91
      Height = 17
      Caption = 'Tab'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbTabClick
    end
    object rbSemi: TRadioButton
      Left = 110
      Top = 20
      Width = 91
      Height = 17
      Caption = 'Semicolon'
      TabOrder = 1
      OnClick = rbSemiClick
    end
    object rbComma: TRadioButton
      Left = 110
      Top = 45
      Width = 91
      Height = 17
      Caption = 'Comma'
      TabOrder = 4
      OnClick = rbCommaClick
    end
    object rbOtherDel: TRadioButton
      Left = 220
      Top = 45
      Width = 76
      Height = 17
      Caption = 'Other'
      TabOrder = 5
      OnClick = rbOtherDelClick
    end
    object edDelim: TEdit
      Left = 310
      Top = 42
      Width = 46
      Height = 21
      TabOrder = 6
      OnChange = rbOtherDelClick
    end
    object rbSlash: TRadioButton
      Left = 220
      Top = 20
      Width = 91
      Height = 17
      Caption = 'Slash'
      TabOrder = 2
      OnClick = rbSlashClick
    end
  end
  object edFilename: TEdit
    Left = 5
    Top = 5
    Width = 581
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 8
  end
  object reReduce: TRangeEdit
    Left = 190
    Top = 390
    Width = 31
    Height = 21
    TabOrder = 9
    OnChange = SettingsChange
    Value = 1
    MinValue = 1
    MaxValue = 1000
  end
  object udReduce: TNumUpDown
    Left = 221
    Top = 390
    Width = 16
    Height = 21
    Associate = reReduce
    TabOrder = 10
  end
end
