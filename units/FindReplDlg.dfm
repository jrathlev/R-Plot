object FindReplDialog: TFindReplDialog
  Left = 100
  Top = 100
  ActiveControl = cbxSearch
  BorderStyle = bsDialog
  Caption = 'Search and replace'
  ClientHeight = 287
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  Position = poDesigned
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlSearch: TPanel
    Left = 0
    Top = 0
    Width = 366
    Height = 31
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 8
      Width = 54
      Height = 13
      Caption = 'Search for:'
    end
    object cbxSearch: TComboBox
      Left = 85
      Top = 5
      Width = 276
      Height = 21
      TabOrder = 0
      OnChange = cbxSearchChange
      OnExit = cbxSearchChange
    end
  end
  object pnlControls: TPanel
    Left = 0
    Top = 89
    Width = 366
    Height = 198
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 5
      Top = 5
      Width = 176
      Height = 61
      Caption = 'Options'
      TabOrder = 0
      object cbCase: TCheckBox
        Left = 15
        Top = 17
        Width = 146
        Height = 17
        Caption = 'Case sensitive'
        TabOrder = 0
        OnClick = cbCaseClick
      end
      object cbWord: TCheckBox
        Left = 15
        Top = 37
        Width = 146
        Height = 17
        Caption = 'Whole words'
        TabOrder = 1
        OnClick = cbWordClick
      end
    end
    object rgpStart: TRadioGroup
      Left = 185
      Top = 70
      Width = 176
      Height = 61
      Caption = 'Start '
      ItemIndex = 0
      Items.Strings = (
        'from cursor'
        'from beginning')
      TabOrder = 3
      OnClick = rgpStartClick
    end
    object rgpDirection: TRadioGroup
      Left = 185
      Top = 5
      Width = 176
      Height = 61
      Caption = 'Direction'
      ItemIndex = 0
      Items.Strings = (
        'Forward'
        'Backward')
      TabOrder = 2
      OnClick = rgpDirectionClick
    end
    object rgpRange: TRadioGroup
      Left = 5
      Top = 70
      Width = 176
      Height = 61
      Caption = 'Range'
      ItemIndex = 0
      Items.Strings = (
        'Whole text'
        'Selected text')
      TabOrder = 1
      OnClick = rgpRangeClick
    end
    object CancelBtn: TButton
      Left = 274
      Top = 165
      Width = 86
      Height = 26
      Cancel = True
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 6
      OnClick = CancelBtnClick
    end
    object btnSearch: TButton
      Left = 185
      Top = 165
      Width = 86
      Height = 26
      Caption = '&Search'
      Default = True
      TabOrder = 4
      OnClick = btnSearchClick
    end
    object btnReplAll: TButton
      Left = 5
      Top = 166
      Width = 86
      Height = 25
      Caption = 'Replace &all'
      TabOrder = 7
      OnClick = btnReplAllClick
    end
    object btnRepeat: TButton
      Left = 95
      Top = 165
      Width = 86
      Height = 26
      Caption = '&Continue'
      TabOrder = 5
      OnClick = btnRepeatClick
    end
    object cbAutoclose: TCheckBox
      Left = 20
      Top = 140
      Width = 326
      Height = 17
      Caption = 'Keep this window opened'
      TabOrder = 8
    end
  end
  object pnlReplace: TPanel
    Left = 0
    Top = 35
    Width = 366
    Height = 51
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 5
      Top = 8
      Width = 57
      Height = 13
      Caption = 'Replace by:'
    end
    object cbxReplace: TComboBox
      Left = 85
      Top = 5
      Width = 276
      Height = 21
      TabOrder = 0
    end
    object cbConfirm: TCheckBox
      Left = 85
      Top = 35
      Width = 261
      Height = 17
      Caption = 'With confirmation'
      TabOrder = 1
      OnClick = cbConfirmClick
    end
  end
end
