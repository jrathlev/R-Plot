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
    Top = 389
    Width = 71
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Glyph.Data = {
      BE060000424DBE06000000000000360400002800000024000000120000000100
      0800000000008802000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
      A400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
      0303030303030303030303030303030303030303030303030303030303030303
      03030303030303030303030303030303030303030303FF030303030303030303
      03030303030303040403030303030303030303030303030303F8F8FF03030303
      03030303030303030303040202040303030303030303030303030303F80303F8
      FF030303030303030303030303040202020204030303030303030303030303F8
      03030303F8FF0303030303030303030304020202020202040303030303030303
      0303F8030303030303F8FF030303030303030304020202FA0202020204030303
      0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
      040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
      03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
      FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
      0303030303030303030303FA0202020403030303030303030303030303F8FF03
      03F8FF03030303030303030303030303FA020202040303030303030303030303
      0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
      03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
      030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
      0202040303030303030303030303030303F8FF03F8FF03030303030303030303
      03030303FA0202030303030303030303030303030303F8FFF803030303030303
      030303030303030303FA0303030303030303030303030303030303F803030303
      0303030303030303030303030303030303030303030303030303030303030303
      0303}
    ModalResult = 1
    NumGlyphs = 2
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 488
    Top = 389
    Width = 101
    Height = 26
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Glyph.Data = {
      BE060000424DBE06000000000000360400002800000024000000120000000100
      0800000000008802000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
      A400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
      0303030303030303030303030303030303030303030303030303030303030303
      0303F8F80303030303030303030303030303030303FF03030303030303030303
      0303030303F90101F80303030303F9F80303030303030303F8F8FF0303030303
      03FF03030303030303F9010101F8030303F90101F8030303030303F8FF03F8FF
      030303FFF8F8FF030303030303F901010101F803F901010101F80303030303F8
      FF0303F8FF03FFF80303F8FF030303030303F901010101F80101010101F80303
      030303F8FF030303F8FFF803030303F8FF030303030303F90101010101010101
      F803030303030303F8FF030303F803030303FFF80303030303030303F9010101
      010101F8030303030303030303F8FF030303030303FFF8030303030303030303
      030101010101F80303030303030303030303F8FF0303030303F8030303030303
      0303030303F901010101F8030303030303030303030303F8FF030303F8030303
      0303030303030303F90101010101F8030303030303030303030303F803030303
      F8FF030303030303030303F9010101F8010101F803030303030303030303F803
      03030303F8FF0303030303030303F9010101F803F9010101F803030303030303
      03F8030303F8FF0303F8FF03030303030303F90101F8030303F9010101F80303
      03030303F8FF0303F803F8FF0303F8FF03030303030303F9010303030303F901
      0101030303030303F8FFFFF8030303F8FF0303F8FF0303030303030303030303
      030303F901F903030303030303F8F80303030303F8FFFFFFF803030303030303
      03030303030303030303030303030303030303030303030303F8F8F803030303
      0303030303030303030303030303030303030303030303030303030303030303
      0303}
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
