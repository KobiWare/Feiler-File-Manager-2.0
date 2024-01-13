Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Rename File'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Enter the full path of the file:'
$form.Controls.Add($label)

$textBoxPath = New-Object System.Windows.Forms.TextBox
$textBoxPath.Location = New-Object System.Drawing.Point(10,40)
$textBoxPath.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxPath)

$labelNewName = New-Object System.Windows.Forms.Label
$labelNewName.Location = New-Object System.Drawing.Point(10,70)
$labelNewName.Size = New-Object System.Drawing.Size(280,20)
$labelNewName.Text = 'Enter the new name for the file:'
$form.Controls.Add($labelNewName)

$textBoxNewName = New-Object System.Windows.Forms.TextBox
$textBoxNewName.Location = New-Object System.Drawing.Point(10,90)
$textBoxNewName.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxNewName)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10,120)
$button.Size = New-Object System.Drawing.Size(75,23)
$button.Text = 'Rename'
$button.Add_Click({
    Rename-Item -Path $textBoxPath.Text -NewName $textBoxNewName.Text
    [System.Windows.Forms.MessageBox]::Show("File renamed successfully!")
})
$form.Controls.Add($button)

$form.ShowDialog()