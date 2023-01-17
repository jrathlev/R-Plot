object PreferencesDialog: TPreferencesDialog
  Left = 227
  Top = 108
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  ClientHeight = 311
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
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
          object bbBgColor: TBitBtn
            Left = 340
            Top = 55
            Width = 56
            Height = 31
            Glyph.Data = {
              96090000424D9609000000000000360000002800000028000000140000000100
              18000000000060090000120B0000120B00000000000000000000C0DCC0C0DCC0
              C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
              C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
              DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
              C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
              C0C0DCC0A7C5BA3458990C398E0F398C3153968DABB2BDD9BFC0DCC0C0DCC0C0
              DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
              B1C9B1666E664C4D4C4E4F4E636B639FB49FBEDABEC0DCC0C0DCC0C0DCC0C0DC
              C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BEDAC0597DA837
              7FBE4FBCE43DA1D5226BAD113F925777A1B2CFBCC0DCC0C0DCC0C0DCC0C0DCC0
              C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BFDBBF808D807B7B7B9999
              998989896868685152517C897CB7D1B7C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
              DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0A3C2BA4574B495DAF27CE3FF66D4FF
              5DCCFA3FA3D6195CA42C509593AFB2BFDBC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
              C0C0DCC0C0DCC0C0DCC0C0DCC0AEC6AE7D837DC3C3C3BEBEBEB3B3B3ACACAC8A
              8A8A5E5E5E606660A2B8A2BFDBBFC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0B3D0BC
              A7C4B9C0DCC0C0DCC091B3B85484C3A6E3F876D7FF68CEFF69CEFF66D2FF4DBD
              ED2577B71E46927F9BAABEDABFC0DCC0C0DCC0C0DCC0C0DCC0B8D2B8B0C8B0C0
              DCC0C0DCC0A5BAA58B8F8BCFCFCFBBBBBBB4B4B4B4B4B4B3B3B39D9D9D6E6E6E
              585C5895A895BFDABFC0DCC0C0DCC0C0DCC0BDD9BF50709C315A9A88ABB5C0DC
              C0A1C2BD5388C3A2DFF67CDDFF6CD2FF68CEFF65C9FF63CCFF52C4F62C8AC61E
              49927790A5BCD8BFC0DCC0C0DCC0BEDABE768176666C669FB39FC0DCC0AFC6AF
              8C918CCCCCCCBEBEBEB6B6B6B4B4B4B2B2B2B1B1B1A4A4A4797979575A578E9F
              8EBED9BEC0DCC0C0DCC08BA4AD305DA6619FCB1B56A36993B4A1C4BE538CC499
              D7F385E2FF70D5FF6BD0FF65CCFF60C7FF5FCAFF53C7FC2E91CD1B428E8096A5
              BFDBC0C0DCC09CB09C6C6C6C9696965F625F8E9E8EB0C7B08C958CC6C6C6C2C2
              C2B8B8B8B5B5B5B2B2B2B0B0B0AFAFAFA8A8A87E7E7E54575492A592BFDBBFC0
              DCC03A549386AED5A9F4FD4BA8D7286DB42B68B23F7FC6A3DFF587E4FF73D6FF
              6CD1FF67CCFF61C7FF5DC6FF5FCEFF54D0FD2C90CA1F37839EB6B0C0DCC0666F
              66AEAEAED3D3D39191916E6F6E6E746E828682CCCCCCC3C3C3B9B9B9B6B6B6B3
              B3B3B0B0B0AEAEAEAFAFAFA9A9A97B7B7B515551A7BEA7C0DCC02B4697B3DDF2
              89E5FF7AE1FE77D4EF5CAFD991C9E5A3E8FD7CDEFF73D5FF6CD1FF66CCFF61CA
              FF5FCCFD52B3EC4FADEA4BC7FA267CBB3C4B84B7D2BC616361D2D2D2C4C4C4BC
              BCBCB3B3B39A9A9ABBBBBBD0D0D0BEBEBEB9B9B9B6B6B6B3B3B3B0B0B0AEAEAE
              9F9F9F9C9C9CA3A3A3717171606960B9D4B939519FBFEBFA79D9FE73CDF882DC
              FB8EEDFD8EE9FE80DFFF78D9FF72D3FF6AD0FF67CFFF5EC6F93570D70E1FC80C
              18BD1B3DB7257DC7133D898498A16C6D6CDCDCDCBCBCBCB6B6B6BFBFBFC5C5C5
              C6C6C6BFBFBFBCBCBCB9B9B9B5B5B5B3B3B3ACACAC8686866B6B6B6565656969
              697676764E4E4E93A6933A519CBDE6F64DA5E22692DF3794DF5FB1E57CDCFA78
              DDFF72D6FF6DD2FF68CDFF66D0FF4EA4E60710C30000F50000F10000C11F5AC6
              287BB935417A6B6C6BD9D9D99797978282828B8B8BA2A2A2BBBBBBBCBCBCB9B9
              B9B6B6B6B4B4B4B3B3B39A9A9A6565657B7B7B79797961616173737371717158
              5F5830438EA3BADF42B3E725E9FE39CFFC3799E354A3E171D2FA70D6FF6BD0FF
              65CCFF62CCFF56B8F21F43C3040AD10307F20F20DA439FED3BADE21930795F63
              5FC1C1C19494949191919A9A9A8D8D8D9A9A9AB6B6B6B8B8B8B5B5B5B2B2B2B1
              B1B1A4A4A47171716B6B6B7B7B7B7575759898988E8E8E494B495D7097586BAF
              5CCAF029EBFC40D7FB47BAF648A0E966C4F96CCFFE69CAFF66CCFF5EC7FF5DC9
              FF55BEF63182E2266EE7429EF157C7FD45BAF2153B857B887B838383A6A6A692
              92929D9D9D9E9E9E989898B0B0B0B5B5B5B4B4B4B3B3B3AFAFAFAEAEAEA6A6A6
              898989868686999999AAAAAA9B9B9B4D4E4DB0CBBA35458B6EA2D164D3F743B5
              F04EAFF15AB7F24DABC93798A1389BAC4BACD85AC2FC51C7FF4DBFFB60B1D667
              ACC953BAEE53C3FF49BCF4153C87B5CFB5606660A0A0A0AEAEAE999999A0A0A0
              A6A6A68B8B8B6C6C6C727272919191ABABABA8A8A8A4A4A49B9B9B989898A1A1
              A1A9A9A99E9E9E4E4E4EC0DCC090A7AB454F938DB2DA86DCFF69D5FF4FB2D324
              9D3D09A315009E170E854F4AA8E762A7CF898188CA8753D98A457B91A64DC4FC
              43AFE8182D7AC0DCC09EB39E6C706CB4B4B4C2C2C2B4B4B49191916161615656
              564F4F4F4949499898989898988585858E8E8E8F8F8F909090A5A5A595959549
              4B49C0DCC0C0DCC08BA0A94353926993C285DAF66BD3EA3DC07116B628079F26
              20977C4EA5E5BB7959FD7B19FF9936FFA031AE968153C6FC296FB7455180C0DC
              C0C0DCC09AAF9A6B716B959595BEBEBEABABAB7F7F7F6666665353535B5B5B99
              99998A8A8A8B8B8B9A9A9A989898979797A8A8A8707070626C62C0DCC0C0DCC0
              C0DCC0A3BBB35F6F973B589B5C9ACD65C4E352C9C349BDCB55C3F557C2FB91A0
              ABC8916CE48E54D79D698BB1BC3583CB2C407EA1B8AFC0DCC0C0DCC0C0DCC0AB
              C3AB7B887B6C6D6C949494A4A4A48D8D8D8A8A8AA5A5A5A9A9A99E9E9E9A9A9A
              9C9C9CA0A0A0A4A4A4808080555B55A8BFA8C0DCC0C0DCC0C0DCC0C0DCC0B9D5
              BD9AB1AF5F70962C44913569B4479AD94CB9EB4AC7F743C9FF45C0F14EB1DD4A
              94CE2659A737487E9CB3ADC0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BBD7BBA5BBA5
              7B887B5F625F7575759090909B9B9BA1A1A1A1A1A19B9B9B9595958C8C8C6767
              675B625BA4BBA4C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BAD6BEAA
              C3B67E91A0485789273D801C41881243900B47930E418E283F816D7F94AEC8B6
              C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0BCD7BCB0C9B08FA1
              8F6872685358535254525152514F504F4E504E555A55819181B2CCB2C0DCC0C0
              DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
              C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
              C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
              DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0}
            NumGlyphs = 2
            TabOrder = 3
            OnClick = bbBgColorClick
          end
          object paOrientation: TPanel
            Left = 5
            Top = 60
            Width = 176
            Height = 31
            BevelOuter = bvNone
            Caption = 'paOrientation'
            ShowCaption = False
            TabOrder = 4
            object rbLandscape: TRadioButton
              Left = 85
              Top = 5
              Width = 79
              Height = 17
              Caption = 'Landscape'
              TabOrder = 0
              OnClick = cbFormsCloseUp
            end
            object rbPortrait: TRadioButton
              Left = 5
              Top = 5
              Width = 71
              Height = 17
              Caption = 'Portrait'
              Checked = True
              TabOrder = 1
              TabStop = True
              OnClick = cbFormsCloseUp
            end
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
      Top = 10
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
    object OKBtn: TBitBtn
      Left = 246
      Top = 10
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
    object bbDefault: TBitBtn
      Left = 210
      Top = 10
      Width = 31
      Height = 31
      Hint = 'Reset to program defaults'
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000120B0000120B00000000000000000000C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D
        5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C88888C88888C88888C88888C88888C
        88888C88888C88888C88888C88888C8888C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF605D
        5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8888C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        605D5DFFFFFF605D5D605D5D605D5D605D5D605D5D257925257925FFFFFF2579
        25257925C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFF8C88888C88888C88888C
        88888C88886B6B6B6B6B6BFFFFFF6B6B6B6B6B6BC0DCC0C0DCC0C0DCC0C0DCC0
        605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2579254ECF4E2579254ECF
        4E257925C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF6B6B6BB4B4B46B6B6BB4B4B46B6B6BC0DCC0C0DCC0C0DCC0C0DCC0
        605D5DFFFFFF605D5D605D5D605D5D2579252579254ECF4E4ECF4E4ECF4E56D1
        564ECF4E257925257925C0DCC0C0DCC08C8888FFFFFF8C88888C88888C88886B
        6B6B6B6B6BB4B4B4B4B4B4B4B4B4B7B7B7B4B4B46B6B6B6B6B6BC0DCC0C0DCC0
        605D5DFFFFFFFFFFFFFFFFFFFFFFFF2579254ECF4E4ECF4E4ECF4EFFFFFF4ECF
        4E4ECF4E4ECF4E257925C0DCC0C0DCC08C8888FFFFFFFFFFFFFFFFFFFFFFFF6B
        6B6BB4B4B4B4B4B4B4B4B4FFFFFFB4B4B4B4B4B4B4B4B46B6B6BC0DCC0C0DCC0
        605D5DFFFFFF605D5D605D5D605D5D605D5D2579254ECF4E605D5DFFFFFF605D
        5D4ECF4E257925C0DCC0C0DCC0C0DCC08C8888FFFFFF8C88888C88888C88888C
        88886B6B6BB4B4B48C8888FFFFFF8C8888B4B4B46B6B6BC0DCC0C0DCC0C0DCC0
        605D5DFFFFFFFFFFFFFFFFFFFFFFFF2579254ECF4E4ECF4E4ECF4EFFFFFF4ECF
        4E4ECF4E4ECF4E257925C0DCC0C0DCC08C8888FFFFFFFFFFFFFFFFFFFFFFFF6B
        6B6BB4B4B4B4B4B4B4B4B4FFFFFFB4B4B4B4B4B4B4B4B46B6B6BC0DCC0C0DCC0
        605D5DFFFFFF605D5D605D5D605D5D2579252579254ECF4E4ECF4E4ECF4E4ECF
        4E4ECF4E257925257925C0DCC0C0DCC08C8888FFFFFF8C88888C88888C88886B
        6B6B6B6B6BB4B4B4B4B4B4B4B4B4B4B4B4B4B4B46B6B6B6B6B6BC0DCC0C0DCC0
        605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2579254ECF4E2579254ECF
        4E257925C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF6B6B6BB4B4B46B6B6BB4B4B46B6B6BC0DCC0C0DCC0C0DCC0C0DCC0
        605D5DFFFFFF605D5D605D5D605D5D605D5D605D5D257925257925FFFFFF2579
        25257925C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFF8C88888C88888C88888C
        88888C88886B6B6B6B6B6BFFFFFF6B6B6B6B6B6BC0DCC0C0DCC0C0DCC0C0DCC0
        605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF605D
        5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8888C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        605D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF605D
        5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C8888FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8888C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D5D605D
        5DC0DCC0C0DCC0C0DCC0C0DCC0C0DCC08C88888C88888C88888C88888C88888C
        88888C88888C88888C88888C88888C8888C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DC
        C0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0
        DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0C0DCC0}
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
      Top = 10
      Width = 31
      Height = 31
      Hint = 'Load preferences from file'
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
      TabOrder = 3
      OnClick = bbLoadTemplateClick
    end
    object bbSavePrefs: TBitBtn
      Left = 176
      Top = 10
      Width = 31
      Height = 31
      Hint = 'Save preferences to file'
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
