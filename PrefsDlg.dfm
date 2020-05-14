object PreferencesDialog: TPreferencesDialog
  Left = 227
  Top = 108
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  ClientHeight = 311
  ClientWidth = 421
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pcPrefs: TPageControl
    Left = 0
    Top = 51
    Width = 421
    Height = 207
    ActivePage = tsSheet
    Align = alClient
    TabOrder = 0
    OnChange = pcPrefsChange
    object tsSheet: TTabSheet
      Caption = 'Sheet'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 413
        Height = 179
        Align = alClient
        ParentBackground = False
        TabOrder = 0
        object gbSize: TGroupBox
          Left = 6
          Top = 1
          Width = 400
          Height = 95
          Caption = 'Size'
          TabOrder = 0
          object Label2: TLabel
            Left = 140
            Top = 30
            Width = 40
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Width:'
          end
          object Label1: TLabel
            Left = 270
            Top = 30
            Width = 40
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Height:'
          end
          object Label5: TLabel
            Left = 188
            Top = 66
            Width = 86
            Height = 13
            Alignment = taRightJustify
            Caption = 'Background color:'
          end
          object shBackground: TShape
            Left = 280
            Top = 60
            Width = 51
            Height = 21
            Pen.Style = psClear
            Pen.Width = 2
          end
          object Label21: TLabel
            Tag = 1
            Left = 232
            Top = 30
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object Label22: TLabel
            Tag = 1
            Left = 362
            Top = 30
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object cbForms: TComboBox
            Left = 10
            Top = 26
            Width = 111
            Height = 21
            Style = csDropDownList
            ItemIndex = 2
            TabOrder = 0
            Text = 'ISO A4'
            OnCloseUp = cbFormsCloseUp
            Items.Strings = (
              'User defined'
              'ISO A3'
              'ISO A4'
              'ISO A5'
              'ISO A6'
              'Letter'
              'Legal')
          end
          object feWidth: TFloatRangeEdit
            Tag = 4
            Left = 185
            Top = 26
            Width = 41
            Height = 21
            Alignment = taRightJustify
            TabOrder = 1
            Digits = 5
            Decimal = 1
            StepMultiplier = 1.000000000000000000
            Value = 21.000000000000000000
            MinValue = 5.000000000000000000
            MaxValue = 100.000000000000000000
          end
          object feHeight: TFloatRangeEdit
            Tag = 4
            Left = 315
            Top = 26
            Width = 41
            Height = 21
            Alignment = taRightJustify
            TabOrder = 2
            Digits = 5
            Decimal = 1
            StepMultiplier = 1.000000000000000000
            Value = 29.700000000000000000
            MinValue = 5.000000000000000000
            MaxValue = 100.000000000000000000
          end
          object rbPortrait: TRadioButton
            Left = 10
            Top = 58
            Width = 71
            Height = 17
            Caption = 'Portrait'
            Checked = True
            TabOrder = 3
            TabStop = True
            OnClick = cbFormsCloseUp
          end
          object rbLandscape: TRadioButton
            Left = 87
            Top = 58
            Width = 79
            Height = 17
            Caption = 'Landscape'
            TabOrder = 4
            OnClick = cbFormsCloseUp
          end
          object bbBgColor: TBitBtn
            Left = 340
            Top = 60
            Width = 51
            Height = 21
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              18000000000000060000C30E0000C30E00000000000000000000CC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF666666
              4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D
              4D4D4D4DCC99FFCC99FFCC99FF9595957E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E
              7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7ECC99FFCC99FFCC99FF666666
              0095FE1171FF2F47D96666662FEB0850DA0068963966666678B54D8FB00C787E
              244D4D4DCC99FFCC99FFCC99FF959595ABABABB4B4B4B0B0B0959595A7A7A79B
              9B9B969696959595ADADAD8E8E8E8282827E7E7ECC99FFCC99FFCC99FF666666
              84D3FF3AADFF0D67E4666666A5FD854CFF1249A52D666666AED39A9DD3456B8C
              314D4D4DCC99FFCC99FFCC99FF959595E7E7E7C6C6C6A6A6A6959595E7E7E7B4
              B4B4979797959595DEDEDEB7B7B78E8E8E7E7E7ECC99FFCC99FFCC99FF666666
              D3BEA059BBD62688B5666666D1A6B472CD4455963C666666AD8D918D9B746174
              564D4D4DCC99FFCC99FFCC99FF959595E1E1E1C1C1C19C9C9C959595E3E3E3B4
              B4B4979797959595C7C7C7B3B3B39494947E7E7ECC99FFCC99FFCC99FF666666
              6666666666666666666666666666666666666666666666666666666666666666
              664D4D4DCC99FFCC99FFCC99FF95959595959595959595959595959595959595
              95959595959595959595959595959595957E7E7ECC99FFCC99FFCC99FF666666
              2651FC241DF7340FC76666664CFAF00AF8FB33A5BC666666F6BE05E89002A869
              214D4D4DCC99FFCC99FFCC99FF959595BCBCBCB5B5B5999999959595CCCCCCAE
              AEAEA5A5A5959595AAAAAAA2A2A29494947E7E7ECC99FFCC99FFCC99FF666666
              AABBF56577FF1823DD666666BDFFF364FFFF47B4BB666666FCE98BFFCE21DE9C
              004D4D4DCC99FFCC99FFCC99FF959595F4F4F4DADADAA8A8A8959595FFFFFFDA
              DADAADADAD959595E9E9E9BBBBBB9D9D9D7E7E7ECC99FFCC99FFCC99FF666666
              C2BCA26380DF2E52B5666666BFACA674DBDD559B9D666666ACAEC2F4D024BC9C
              124D4D4DCC99FFCC99FFCC99FF959595DADADACACACA9F9F9F959595DADADAD2
              D2D2A6A6A6959595DEDEDEB7B7B79696967E7E7ECC99FFCC99FFCC99FF666666
              6666666666666666666666666666666666666666666666666666666666666666
              66666666CC99FFCC99FFCC99FF95959595959595959595959595959595959595
              9595959595959595959595959595959595959595CC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF}
            NumGlyphs = 2
            TabOrder = 5
            OnClick = bbBgColorClick
          end
        end
        object gbMargin: TGroupBox
          Left = 5
          Top = 100
          Width = 401
          Height = 71
          Caption = 'Margins'
          TabOrder = 1
          object Label3: TLabel
            Left = 25
            Top = 20
            Width = 35
            Height = 13
            AutoSize = False
            Caption = 'Left:'
          end
          object Label4: TLabel
            Left = 310
            Top = 20
            Width = 45
            Height = 13
            AutoSize = False
            Caption = 'Bottom:'
          end
          object Label6: TLabel
            Left = 120
            Top = 20
            Width = 40
            Height = 13
            AutoSize = False
            Caption = 'Right:'
          end
          object Label7: TLabel
            Left = 215
            Top = 20
            Width = 35
            Height = 13
            AutoSize = False
            Caption = 'Top:'
          end
          object Label23: TLabel
            Tag = 1
            Left = 72
            Top = 40
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object Label24: TLabel
            Tag = 1
            Left = 167
            Top = 40
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object Label25: TLabel
            Tag = 1
            Left = 262
            Top = 40
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object Label26: TLabel
            Tag = 1
            Left = 357
            Top = 40
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object feLeft: TFloatRangeEdit
            Tag = 4
            Left = 25
            Top = 36
            Width = 41
            Height = 21
            Alignment = taRightJustify
            TabOrder = 0
            Digits = 5
            Decimal = 1
            StepMultiplier = 1.000000000000000000
            Value = 1.000000000000000000
            MaxValue = 5.000000000000000000
          end
          object feBottom: TFloatRangeEdit
            Tag = 4
            Left = 310
            Top = 36
            Width = 41
            Height = 21
            Alignment = taRightJustify
            TabOrder = 3
            Digits = 5
            Decimal = 1
            StepMultiplier = 1.000000000000000000
            Value = 1.000000000000000000
            MaxValue = 5.000000000000000000
          end
          object feRight: TFloatRangeEdit
            Tag = 4
            Left = 120
            Top = 36
            Width = 41
            Height = 21
            Alignment = taRightJustify
            TabOrder = 1
            Digits = 5
            Decimal = 1
            StepMultiplier = 1.000000000000000000
            Value = 1.000000000000000000
            MaxValue = 5.000000000000000000
          end
          object feTop: TFloatRangeEdit
            Tag = 4
            Left = 215
            Top = 36
            Width = 41
            Height = 21
            Alignment = taRightJustify
            TabOrder = 2
            Digits = 5
            Decimal = 1
            StepMultiplier = 1.000000000000000000
            Value = 1.000000000000000000
            MaxValue = 5.000000000000000000
          end
        end
      end
    end
    object tsCharts: TTabSheet
      Caption = 'Charts'
      ImageIndex = 4
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 413
        Height = 179
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object Label8: TLabel
          Left = 115
          Top = 85
          Width = 135
          Height = 13
          Alignment = taRightJustify
          Caption = 'Default space around chart:'
        end
        object Label15: TLabel
          Left = 139
          Top = 120
          Width = 111
          Height = 13
          Alignment = taRightJustify
          Caption = 'Space for axis labeling:'
        end
        object Label27: TLabel
          Tag = 1
          Left = 307
          Top = 85
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object Label28: TLabel
          Tag = 1
          Left = 307
          Top = 120
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object edChartSpace: TFloatRangeEdit
          Tag = 3
          Left = 260
          Top = 81
          Width = 41
          Height = 21
          Alignment = taRightJustify
          TabOrder = 0
          Digits = 10
          StepMultiplier = 1.000000000000000000
          MaxValue = 100.000000000000000000
        end
        object edAxisSpace: TFloatRangeEdit
          Tag = 3
          Left = 260
          Top = 116
          Width = 41
          Height = 21
          Alignment = taRightJustify
          TabOrder = 1
          Digits = 10
          StepMultiplier = 1.000000000000000000
          MaxValue = 100.000000000000000000
        end
        object gbBackground: TGroupBox
          Left = 5
          Top = 10
          Width = 401
          Height = 56
          Caption = 'Background'
          TabOrder = 2
          DesignSize = (
            401
            56)
          object laChartColor: TLabel
            Left = 170
            Top = 25
            Width = 69
            Height = 13
            Alignment = taRightJustify
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = 'Color:'
          end
          object shChartBg: TShape
            Left = 245
            Top = 20
            Width = 51
            Height = 21
            Pen.Style = psClear
            Pen.Width = 2
          end
          object bbChartBg: TBitBtn
            Left = 305
            Top = 20
            Width = 51
            Height = 21
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              18000000000000060000C30E0000C30E00000000000000000000CC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF666666
              4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D
              4D4D4D4DCC99FFCC99FFCC99FF9595957E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E
              7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7ECC99FFCC99FFCC99FF666666
              0095FE1171FF2F47D96666662FEB0850DA0068963966666678B54D8FB00C787E
              244D4D4DCC99FFCC99FFCC99FF959595ABABABB4B4B4B0B0B0959595A7A7A79B
              9B9B969696959595ADADAD8E8E8E8282827E7E7ECC99FFCC99FFCC99FF666666
              84D3FF3AADFF0D67E4666666A5FD854CFF1249A52D666666AED39A9DD3456B8C
              314D4D4DCC99FFCC99FFCC99FF959595E7E7E7C6C6C6A6A6A6959595E7E7E7B4
              B4B4979797959595DEDEDEB7B7B78E8E8E7E7E7ECC99FFCC99FFCC99FF666666
              D3BEA059BBD62688B5666666D1A6B472CD4455963C666666AD8D918D9B746174
              564D4D4DCC99FFCC99FFCC99FF959595E1E1E1C1C1C19C9C9C959595E3E3E3B4
              B4B4979797959595C7C7C7B3B3B39494947E7E7ECC99FFCC99FFCC99FF666666
              6666666666666666666666666666666666666666666666666666666666666666
              664D4D4DCC99FFCC99FFCC99FF95959595959595959595959595959595959595
              95959595959595959595959595959595957E7E7ECC99FFCC99FFCC99FF666666
              2651FC241DF7340FC76666664CFAF00AF8FB33A5BC666666F6BE05E89002A869
              214D4D4DCC99FFCC99FFCC99FF959595BCBCBCB5B5B5999999959595CCCCCCAE
              AEAEA5A5A5959595AAAAAAA2A2A29494947E7E7ECC99FFCC99FFCC99FF666666
              AABBF56577FF1823DD666666BDFFF364FFFF47B4BB666666FCE98BFFCE21DE9C
              004D4D4DCC99FFCC99FFCC99FF959595F4F4F4DADADAA8A8A8959595FFFFFFDA
              DADAADADAD959595E9E9E9BBBBBB9D9D9D7E7E7ECC99FFCC99FFCC99FF666666
              C2BCA26380DF2E52B5666666BFACA674DBDD559B9D666666ACAEC2F4D024BC9C
              124D4D4DCC99FFCC99FFCC99FF959595DADADACACACA9F9F9F959595DADADAD2
              D2D2A6A6A6959595DEDEDEB7B7B79696967E7E7ECC99FFCC99FFCC99FF666666
              6666666666666666666666666666666666666666666666666666666666666666
              66666666CC99FFCC99FFCC99FF95959595959595959595959595959595959595
              9595959595959595959595959595959595959595CC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF}
            NumGlyphs = 2
            TabOrder = 0
            OnClick = bbChartBgClick
          end
          object cxTranspChart: TCheckBox
            Left = 35
            Top = 25
            Width = 111
            Height = 17
            Caption = 'Transparent'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = cxTranspChartClick
          end
        end
      end
    end
    object tsAxes: TTabSheet
      Caption = 'Axes'
      ImageIndex = 5
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 413
        Height = 179
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object Label36: TLabel
          Left = 25
          Top = 125
          Width = 52
          Height = 13
          Alignment = taRightJustify
          Caption = 'Line width:'
        end
        object Label37: TLabel
          Tag = 1
          Left = 137
          Top = 125
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object Label38: TLabel
          Left = 210
          Top = 125
          Width = 90
          Height = 13
          Alignment = taRightJustify
          Caption = 'Decimal separator:'
        end
        object Label39: TLabel
          Left = 25
          Top = 155
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = 'Tick length:'
        end
        object Label40: TLabel
          Tag = 1
          Left = 137
          Top = 155
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object cxBorder: TCheckBox
          Left = 210
          Top = 155
          Width = 176
          Height = 17
          Caption = 'Enframe chart with axes'
          TabOrder = 0
        end
        object gbLabels: TGroupBox
          Left = 5
          Top = 5
          Width = 396
          Height = 51
          Caption = 'Labels'
          TabOrder = 1
          object Label16: TLabel
            Left = 60
            Top = 20
            Width = 80
            Height = 13
            Alignment = taRightJustify
            Caption = 'Distance to axis:'
          end
          object Label19: TLabel
            Left = 245
            Top = 20
            Width = 47
            Height = 13
            Alignment = taRightJustify
            Caption = 'Font size:'
          end
          object Label29: TLabel
            Tag = 1
            Left = 197
            Top = 20
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object Label30: TLabel
            Tag = 1
            Left = 352
            Top = 20
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object feLabDist: TFloatRangeEdit
            Tag = 3
            Left = 145
            Top = 16
            Width = 46
            Height = 21
            Alignment = taRightJustify
            TabOrder = 0
            Digits = 10
            StepMultiplier = 1.000000000000000000
            MaxValue = 100.000000000000000000
          end
          object feLabSize: TFloatRangeEdit
            Left = 300
            Top = 15
            Width = 46
            Height = 21
            Alignment = taRightJustify
            TabOrder = 1
            Digits = 4
            StepMultiplier = 1.000000000000000000
            MinValue = 0.100000000000000000
            MaxValue = 10.000000000000000000
          end
        end
        object gbCaption: TGroupBox
          Left = 5
          Top = 60
          Width = 396
          Height = 51
          Caption = 'Caption'
          TabOrder = 2
          object Label17: TLabel
            Left = 60
            Top = 20
            Width = 80
            Height = 13
            Alignment = taRightJustify
            Caption = 'Distance to axis:'
          end
          object Label20: TLabel
            Left = 245
            Top = 20
            Width = 47
            Height = 13
            Alignment = taRightJustify
            Caption = 'Font size:'
          end
          object Label31: TLabel
            Tag = 1
            Left = 197
            Top = 20
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object Label32: TLabel
            Tag = 1
            Left = 352
            Top = 20
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object feCapDist: TFloatRangeEdit
            Tag = 3
            Left = 145
            Top = 16
            Width = 46
            Height = 21
            Alignment = taRightJustify
            TabOrder = 0
            Digits = 10
            StepMultiplier = 1.000000000000000000
            MaxValue = 100.000000000000000000
          end
          object feCapSize: TFloatRangeEdit
            Tag = 3
            Left = 300
            Top = 16
            Width = 46
            Height = 21
            Alignment = taRightJustify
            TabOrder = 1
            Digits = 4
            StepMultiplier = 1.000000000000000000
            MinValue = 0.100000000000000000
            MaxValue = 10.000000000000000000
          end
        end
        object feAxLnWidth: TFloatRangeEdit
          Left = 85
          Top = 120
          Width = 46
          Height = 21
          Alignment = taRightJustify
          TabOrder = 3
          Digits = 4
          StepMultiplier = 1.000000000000000000
          Value = 0.050000000000000000
          MinValue = 0.100000000000000000
          MaxValue = 10.000000000000000000
        end
        object cbDecSep: TComboBox
          Left = 305
          Top = 120
          Width = 76
          Height = 21
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 4
          Text = 'Comma'
          Items.Strings = (
            'Point'
            'Comma')
        end
        object feTickLength: TFloatRangeEdit
          Tag = 3
          Left = 85
          Top = 150
          Width = 46
          Height = 21
          Alignment = taRightJustify
          TabOrder = 5
          Digits = 4
          Decimal = 1
          StepMultiplier = 1.000000000000000000
          Value = 0.300000000000000000
          MinValue = 0.020000000000000000
          MaxValue = 10.000000000000000000
        end
      end
    end
    object tsLines: TTabSheet
      Caption = 'Lines and symbols'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 413
        Height = 179
        Align = alClient
        ParentBackground = False
        TabOrder = 0
        object gbLines: TGroupBox
          Left = 10
          Top = 5
          Width = 396
          Height = 56
          Caption = 'Lines'
          TabOrder = 0
          object Label10: TLabel
            Left = 15
            Top = 25
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Caption = 'Width:'
          end
          object Label11: TLabel
            Left = 125
            Top = 25
            Width = 28
            Height = 13
            Alignment = taRightJustify
            Caption = 'Style:'
          end
          object Label12: TLabel
            Left = 287
            Top = 25
            Width = 29
            Height = 13
            Alignment = taRightJustify
            Caption = 'Color:'
          end
          object sbLineColor: TSpeedButton
            Left = 320
            Top = 20
            Width = 61
            Height = 21
            OnClick = sbLineColorClick
          end
          object Label33: TLabel
            Tag = 1
            Left = 97
            Top = 25
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object cxStyle: TComboBox
            Left = 160
            Top = 20
            Width = 111
            Height = 21
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 0
            Text = 'Solid'
            Items.Strings = (
              'Solid'
              'Dashed'
              'Dotted')
          end
          object edLineWidth: TFloatRangeEdit
            Left = 50
            Top = 20
            Width = 41
            Height = 21
            Alignment = taRightJustify
            TabOrder = 1
            Digits = 4
            StepMultiplier = 1.000000000000000000
            Value = 0.050000000000000000
            MinValue = 0.100000000000000000
            MaxValue = 10.000000000000000000
          end
        end
        object gbSymbols: TGroupBox
          Left = 10
          Top = 65
          Width = 396
          Height = 56
          Caption = 'Symbols'
          TabOrder = 1
          object Label13: TLabel
            Left = 125
            Top = 25
            Width = 28
            Height = 13
            Alignment = taRightJustify
            Caption = 'Type:'
          end
          object laSymbolSize: TLabel
            Left = 22
            Top = 25
            Width = 23
            Height = 13
            Alignment = taRightJustify
            Caption = 'Size:'
          end
          object Label14: TLabel
            Left = 287
            Top = 25
            Width = 29
            Height = 13
            Alignment = taRightJustify
            Caption = 'Color:'
          end
          object sbSymColor: TSpeedButton
            Left = 320
            Top = 20
            Width = 61
            Height = 21
            OnClick = sbSymColorClick
          end
          object Label34: TLabel
            Tag = 1
            Left = 97
            Top = 25
            Width = 13
            Height = 13
            Caption = 'cm'
          end
          object cxSymbols: TComboBox
            Left = 160
            Top = 20
            Width = 111
            Height = 21
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 0
            Text = 'Dot'
            Items.Strings = (
              'Dot'
              'Diamond - solid'
              'Triangle - solid'
              'Square - solid'
              'Delta - solid'
              'Circle'
              'Diamond - outline'
              'Triangle - outline'
              'Square - outline'
              'Delta - outline'
              'Plus'
              'Cross'
              'None')
          end
          object edSymbolSize: TFloatRangeEdit
            Tag = 3
            Left = 50
            Top = 20
            Width = 41
            Height = 21
            Alignment = taRightJustify
            TabOrder = 1
            Digits = 4
            Decimal = 1
            StepMultiplier = 1.000000000000000000
            Value = 0.300000000000000000
            MinValue = 0.020000000000000000
            MaxValue = 10.000000000000000000
          end
        end
        object GroupBox1: TGroupBox
          Left = 10
          Top = 125
          Width = 396
          Height = 46
          Caption = 'Fill color'
          TabOrder = 2
          object laFillColor: TLabel
            Left = 215
            Top = 20
            Width = 29
            Height = 13
            Alignment = taRightJustify
            Caption = 'Color:'
          end
          object shFill: TShape
            Left = 265
            Top = 15
            Width = 51
            Height = 21
            Pen.Style = psClear
            Pen.Width = 2
          end
          object cxNoFill: TCheckBox
            Left = 55
            Top = 19
            Width = 111
            Height = 17
            Caption = 'Transparent'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = cxTranspChartClick
          end
          object bbFillColor: TBitBtn
            Left = 325
            Top = 15
            Width = 51
            Height = 21
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              18000000000000060000C30E0000C30E00000000000000000000CC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF666666
              4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D
              4D4D4D4DCC99FFCC99FFCC99FF9595957E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E
              7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7ECC99FFCC99FFCC99FF666666
              0095FE1171FF2F47D96666662FEB0850DA0068963966666678B54D8FB00C787E
              244D4D4DCC99FFCC99FFCC99FF959595ABABABB4B4B4B0B0B0959595A7A7A79B
              9B9B969696959595ADADAD8E8E8E8282827E7E7ECC99FFCC99FFCC99FF666666
              84D3FF3AADFF0D67E4666666A5FD854CFF1249A52D666666AED39A9DD3456B8C
              314D4D4DCC99FFCC99FFCC99FF959595E7E7E7C6C6C6A6A6A6959595E7E7E7B4
              B4B4979797959595DEDEDEB7B7B78E8E8E7E7E7ECC99FFCC99FFCC99FF666666
              D3BEA059BBD62688B5666666D1A6B472CD4455963C666666AD8D918D9B746174
              564D4D4DCC99FFCC99FFCC99FF959595E1E1E1C1C1C19C9C9C959595E3E3E3B4
              B4B4979797959595C7C7C7B3B3B39494947E7E7ECC99FFCC99FFCC99FF666666
              6666666666666666666666666666666666666666666666666666666666666666
              664D4D4DCC99FFCC99FFCC99FF95959595959595959595959595959595959595
              95959595959595959595959595959595957E7E7ECC99FFCC99FFCC99FF666666
              2651FC241DF7340FC76666664CFAF00AF8FB33A5BC666666F6BE05E89002A869
              214D4D4DCC99FFCC99FFCC99FF959595BCBCBCB5B5B5999999959595CCCCCCAE
              AEAEA5A5A5959595AAAAAAA2A2A29494947E7E7ECC99FFCC99FFCC99FF666666
              AABBF56577FF1823DD666666BDFFF364FFFF47B4BB666666FCE98BFFCE21DE9C
              004D4D4DCC99FFCC99FFCC99FF959595F4F4F4DADADAA8A8A8959595FFFFFFDA
              DADAADADAD959595E9E9E9BBBBBB9D9D9D7E7E7ECC99FFCC99FFCC99FF666666
              C2BCA26380DF2E52B5666666BFACA674DBDD559B9D666666ACAEC2F4D024BC9C
              124D4D4DCC99FFCC99FFCC99FF959595DADADACACACA9F9F9F959595DADADAD2
              D2D2A6A6A6959595DEDEDEB7B7B79696967E7E7ECC99FFCC99FFCC99FF666666
              6666666666666666666666666666666666666666666666666666666666666666
              66666666CC99FFCC99FFCC99FF95959595959595959595959595959595959595
              9595959595959595959595959595959595959595CC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF
              CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99
              FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
              99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF}
            NumGlyphs = 2
            TabOrder = 1
            OnClick = bbFillColorClick
          end
        end
      end
    end
    object tsText: TTabSheet
      Caption = 'Text'
      ImageIndex = 2
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 413
        Height = 179
        Align = alClient
        ParentBackground = False
        TabOrder = 0
        object Label9: TLabel
          Left = 170
          Top = 10
          Width = 23
          Height = 13
          Caption = 'Size:'
        end
        object Label18: TLabel
          Left = 10
          Top = 10
          Width = 26
          Height = 13
          Caption = 'Font:'
        end
        object Label35: TLabel
          Tag = 1
          Left = 222
          Top = 28
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object lbFonts: TListBox
          Left = 10
          Top = 25
          Width = 146
          Height = 141
          TabStop = False
          ItemHeight = 13
          Sorted = True
          TabOrder = 0
          OnClick = lbFontsClick
        end
        object edPreview: TEdit
          Left = 170
          Top = 115
          Width = 231
          Height = 26
          TabStop = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
        object cbItalic: TCheckBox
          Left = 250
          Top = 64
          Width = 56
          Height = 17
          Caption = 'Italic'
          TabOrder = 2
          OnClick = lbFontsClick
        end
        object cbBold: TCheckBox
          Left = 175
          Top = 64
          Width = 66
          Height = 17
          Caption = 'Bold'
          TabOrder = 3
          OnClick = lbFontsClick
        end
        object feSize: TFloatRangeEdit
          Tag = 3
          Left = 170
          Top = 25
          Width = 46
          Height = 21
          Alignment = taRightJustify
          TabOrder = 4
          Digits = 4
          StepMultiplier = 1.000000000000000000
          MinValue = 0.100000000000000000
          MaxValue = 10.000000000000000000
        end
        object bbColor: TBitBtn
          Left = 290
          Top = 20
          Width = 71
          Height = 26
          Hint = 'Select color'
          Caption = 'Color'
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            180000000000000300004E0000004E0000000000000000000000CC99FFCC99FF
            CC99FFCC99FFCC99FFCC99FFCC99FFAFAFAF6666662E2E2E2E2E2E2C2C2C2A2A
            2A626262AEAEAECC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
            99FFA1A1A16666662E2E2E2B2B2B616161A0A0A0CC99FFCC99FFCC99FFCC99FF
            CC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF8585853333333030307F7F
            7FCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC99FFCC
            99FFCC99FF8585853636363131317E7E7ECC99FFCC99FFCC99FFCC99FFCC99FF
            8282B16767B06B6BAF6969AD6565AA7E7EABCC99FF8585853939393434347E7E
            7ECC99FFCC99FFCC99FFCC99FFCC99FF9090B14E4EB12929B22626AE4A4AAA8D
            8DADCC99FF8686853C3C3C3737377F7F7FCC99FFCC99FFCC99FFCC99FFCC99FF
            CC99FF7D7DB13030B63030B37E7EAFCC99FFCC99FF8686864141413A3A3A7F7F
            7FCC99FFCC99FFCC99FFCC99FFCC99FFCC99FF7E7EB33232BA3232B78383B2CC
            99FFCC99FF8787874646463F3F3F808080CC99FFCC99FFCC99FFCC99FFCC99FF
            CC99FF7F7FB33535BE3232B9666692A9A9A8CC99FF8787874B4B4B4646468080
            80CC99FFA9A9A98F8F8FCC99FFCC99FFCC99FF7F7FB53939C22F2FB93535628C
            8C89CC99FF8989895050504A4A4A828282CC99FF868686404040CC99FFCC99FF
            CC99FF8080B63D3DC53131BC3B3B686565617F7F7F6A6A6A5050504A4A4A6161
            617777774A4A4A3B3B3BCC99FFCC99FFCC99FF8080B74242C93A3AC456568578
            78756D6D6C6D6D6A7171706F6F6F676767656565696969717171A6A6B4AFAFB3
            CC99FF8181B84747CD4444CA8181B4CC99FFADADAEA5A5AFCC99FFCC99FFCC99
            FFCC99FFCC99FFCC99FF6060C69797B8CC99FF8282B94B4BD04949CD8585B7CC
            99FF9393B35E5EB4CC99FFCC99FFCC99FFCC99FFCC99FFCC99FF5050D67575CB
            9696B87373BE5252D44F4FD17474BA9393B55F5FBB4343B9CC99FFCC99FFCC99
            FFCC99FFCC99FFCC99FF5454D34F4FD94C4CCE4848CC4A4AD14646CD4242C440
            40C03535C24C4CBACC99FFCC99FFCC99FFCC99FFCC99FFCC99FF}
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = bbColorClick
        end
      end
    end
  end
  object paBottom: TPanel
    Left = 0
    Top = 258
    Width = 421
    Height = 53
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      421
      53)
    object CancelBtn: TBitBtn
      Left = 315
      Top = 15
      Width = 96
      Height = 26
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
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
      TabOrder = 1
    end
    object OKBtn: TBitBtn
      Left = 246
      Top = 15
      Width = 61
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
    object bbDefault: TBitBtn
      Left = 210
      Top = 12
      Width = 31
      Height = 31
      Hint = 'Reset to program defaults'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
        07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
        0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = bbDefaultClick
    end
    object rgUnit: TRadioGroup
      Left = 5
      Top = 0
      Width = 111
      Height = 46
      Caption = 'Unit'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'cm'
        'inch')
      TabOrder = 2
      OnClick = rgUnitClick
    end
    object bbLoadTemplate: TBitBtn
      Left = 141
      Top = 12
      Width = 31
      Height = 31
      Hint = 'Load preferences from file'
      Anchors = [akRight, akBottom]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
        0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
        B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
        FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
        FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
        FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
        0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
        0555555555777777755555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = bbLoadTemplateClick
    end
    object bbSavePrefs: TBitBtn
      Left = 176
      Top = 12
      Width = 31
      Height = 31
      Hint = 'Save preferences to file'
      Anchors = [akRight, akBottom]
      Glyph.Data = {
        96090000424D9609000000000000360000002800000028000000140000000100
        18000000000060090000120B0000120B00000000000000000000FF00FF808080
        8080808080808080808080808080808080808080808080808080808080808080
        80808080808080808080808080808080808080808080FF00FFB2B2B2B2B2B2B2
        B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2
        B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B20000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000808080656565656565656565656565656565656565
        6565656565656565656565656565656565656565656565656565656565656565
        65656565656565B2B2B2000000C0C0C080808080808080808080808080808080
        8080808080808080808080808080808080808080808080808080808080808080
        000000808080656565D9D9D9B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2
        B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2656565B2
        B2B2000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C08080800000008080806565
        65D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9B2B2B2656565B2B2B2000000C0C0C0
        C0C0C0C0C0C00000FF0000FFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000808080656565D9D9D9D9D9D9D9
        D9D9B2B2B2B2B2B2D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9656565B2B2B2000000C0C0C0C0C0C00000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000C0C0C0C0C0C0000000808080656565D9D9D9D9D9D9656565656565656565
        656565656565656565656565656565656565656565656565656565656565D9D9
        D9D9D9D9656565B2B2B2000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        000000808080656565D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9656565B2
        B2B2000000C0C0C0C0C0C0000000000000000000000000000000000000000000
        000000000000000000000000000000000000C0C0C0C0C0C00000008080806565
        65D9D9D9D9D9D965656565656565656565656565656565656565656565656565
        6565656565656565656565656565D9D9D9D9D9D9656565B2B2B2000000FFFFFF
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000808080656565FFFFFFD9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9656565B2B2B2000000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF000000808080656565FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF656565B2B2B200000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000FF00FF6565656565656565656565656565656565656565656565656565
        65656565656565656565656565656565656565656565656565656565656565FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF0000FF808080FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FF7F7F7F7F7F7FFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF0000FF0000FF0000FF0000FF808080FF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF7F7F7F7F7F7F7F7F7F7F7F7FFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
        00FF0000FF0000FF0000FF0000FF0000FF808080FF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7F7F7F7F7F
        7F7F7F7F7F7F7F7F7F7F7F7F7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
        7F7F7F7F7F7F7F7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF0000FF808080FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FF7F7F7F7F7F7FFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF0000FF0000FF808080FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF7F7F7F7F7F7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF0000FF0000FF808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FF7F7F7F7F7F7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF
        0000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7F7F7F7F7F7FFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = bbSavePrefsClick
    end
  end
  object paDesc: TPanel
    Left = 0
    Top = 0
    Width = 421
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object edDesc: TLabeledEdit
      Left = 8
      Top = 20
      Width = 288
      Height = 21
      EditLabel.Width = 57
      EditLabel.Height = 13
      EditLabel.Caption = 'Description:'
      TabOrder = 0
    end
  end
  object ColorDialog: TColorDialog
    Left = 45
    Top = 220
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 105
    Top = 240
  end
  object SaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 150
    Top = 235
  end
end
