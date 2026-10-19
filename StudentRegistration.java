import java.awt.event.*;
import javax.swing.*;

public class StudentRegistration extends JFrame implements ActionListener {

    // Instance Variables[cite: 1]
    private JLabel nameLabel, rollLabel, genderLabel, branchLabel;
    private JTextField nameField, rollField, branchField;
    private JRadioButton maleRadio, femaleRadio;
    private ButtonGroup genderGroup;
    private JCheckBox termsCheckBox;
    private JButton submitButton, resetButton;

    // Constructor to setup the GUI Components[cite: 1]
    public StudentRegistration() {
        // Frame Properties[cite: 1]
        setTitle("Student Registration Form");
        setSize(450, 450);
        setLayout(null); // Absolute positioning[cite: 1]
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); // Close operation[cite: 1]

        // 1. Name Section[cite: 1]
        nameLabel = new JLabel("Name:");
        nameLabel.setBounds(30, 30, 120, 30);
        add(nameLabel);

        nameField = new JTextField();
        nameField.setBounds(150, 30, 200, 30);
        add(nameField);

        // 2. Roll Number Section[cite: 1]
        rollLabel = new JLabel("Roll Number:");
        rollLabel.setBounds(30, 70, 120, 30);
        add(rollLabel);

        rollField = new JTextField();
        rollField.setBounds(150, 70, 200, 30);
        add(rollField);

        // 3. Gender Section[cite: 1]
        genderLabel = new JLabel("Gender:");
        genderLabel.setBounds(30, 110, 120, 30);
        add(genderLabel);

        maleRadio = new JRadioButton("Male");
        maleRadio.setBounds(150, 110, 70, 30);
        femaleRadio = new JRadioButton("Female");
        femaleRadio.setBounds(230, 110, 80, 30);

        // Grouping radio buttons so only one can be selected[cite: 1]
        genderGroup = new ButtonGroup();
        genderGroup.add(maleRadio);
        genderGroup.add(femaleRadio);

        add(maleRadio);
        add(femaleRadio);

        // 4. Branch Section[cite: 1]
        branchLabel = new JLabel("Branch:");
        branchLabel.setBounds(30, 150, 120, 30);
        add(branchLabel);

        branchField = new JTextField();
        branchField.setBounds(150, 150, 200, 30);
        add(branchField);

        // 5. Terms & Conditions Checkbox[cite: 1]
        termsCheckBox = new JCheckBox("Accept Terms & Conditions");
        termsCheckBox.setBounds(30, 200, 250, 30);
        add(termsCheckBox);

        // 6. Submit & Reset Buttons[cite: 1]
        submitButton = new JButton("Submit");
        submitButton.setBounds(50, 260, 100, 35);
        submitButton.addActionListener(this); // Registering action listener[cite: 1]
        add(submitButton);

        resetButton = new JButton("Reset");
        resetButton.setBounds(180, 260, 100, 35);
        resetButton.addActionListener(this); // Registering action listener[cite: 1]
        add(resetButton);

        // Make window visible[cite: 1]
        setVisible(true);
    }

    // Event Handling Method[cite: 1]
    @Override
    public void actionPerformed(ActionEvent e) {

        // Reset Button Logic[cite: 1]
        if (e.getSource() == resetButton) {
            nameField.setText("");
            rollField.setText("");
            branchField.setText("");
            genderGroup.clearSelection();
            termsCheckBox.setSelected(false);
            return; // Exit after reset[cite: 1]
        }

        // Submit Button Logic with Validations[cite: 1]
        if (e.getSource() == submitButton) {

            // Validation for Name[cite: 1]
            if (nameField.getText().trim().isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter your name.");
                return;
            }

            // Validation for Roll Number[cite: 1]
            if (rollField.getText().trim().isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter your roll number.");
                return;
            }

            // Validation for Gender Selection[cite: 1]
            if (!maleRadio.isSelected() && !femaleRadio.isSelected()) {
                JOptionPane.showMessageDialog(this, "Please select your gender.");
                return;
            }

            // Validation for Branch[cite: 1]
            if (branchField.getText().trim().isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter your branch.");
                return;
            }

            // Validation for Terms Acceptance[cite: 1]
            if (!termsCheckBox.isSelected()) {
                JOptionPane.showMessageDialog(this, "Please accept the Terms & Conditions.");
                return;
            }

            // Gender Assignment[cite: 1]
            String gender = maleRadio.isSelected() ? "Male" : "Female";

            // Success Message Dialog displaying registration details[cite: 1]
            String message = "Registration Successful!\n\n" +
                    "Name: " + nameField.getText() + "\n" +
                    "Roll No: " + rollField.getText() + "\n" +
                    "Gender: " + gender + "\n" +
                    "Branch: " + branchField.getText();

            JOptionPane.showMessageDialog(this, message, "Success", JOptionPane.INFORMATION_MESSAGE);
        }
    }

    // Main Method to Launch Application[cite: 1]
    public static void main(String[] args) {
        new StudentRegistration();
    }
}
