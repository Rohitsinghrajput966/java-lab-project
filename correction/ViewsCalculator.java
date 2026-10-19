import javax.swing.*;
public class ViewsCalculator extends JFrame{
    JLabel a, b, result;
    JTextField txta, txtb, txtaresult;
    JButton btnAdd, sub, mul, div;

    public ViewsCalculator() {
        setTitle("Views Calculator");
        setSize(500, 500);
        setLayout(null);
       
    a= new JLabel("Enter first number");
    a.setBounds(30, 30, 100, 25);
    add(a);

    txta= new JTextField();
    txta.setBounds(150, 30, 100, 25);
    add(txta);

    b= new JLabel("Enter second number");
    b.setBounds(30, 70, 100, 25);
    add(b);

    txtb= new JTextField();
    txtb.setBounds(140, 70, 150, 25);
    add(txtb);

    btnAdd= new JButton("Add");
    btnAdd.setBounds(30, 110, 100, 25);
    btnAdd.setActionCommand("add");  
    add(btnAdd);

    sub= new JButton("Subtract");
    sub.setBounds(140, 110, 100, 25);
    sub.setActionCommand("sub");
    add(sub);

    mul= new JButton("Multiply");
    mul.setBounds(250, 110, 100, 25);
    mul.setActionCommand("mul");
    add(mul);   

    div= new JButton("Divide");
    div.setBounds(360, 110, 100, 25);
    div.setActionCommand("div");
    add(div);

    result= new JLabel("Result");
    result.setBounds(30, 150, 100, 25);
    add(result);

    txtaresult= new JTextField();
    txtaresult.setBounds(140, 150, 150, 25);
    txtaresult.setEditable(false);
    add(txtaresult);

    setVisible(true);
    }

}

