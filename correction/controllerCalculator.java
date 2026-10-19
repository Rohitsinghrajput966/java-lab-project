import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class controllerCalculator implements ActionListener {
    ModelsCalculator mc = new ModelsCalculator();
    ViewsCalculator vc = new ViewsCalculator();
    controllerCalculator() {
        vc.btnAdd.addActionListener(this);
        vc.sub.addActionListener(this);
        vc.mul.addActionListener(this);
        vc.div.addActionListener(this);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        double a = Double.parseDouble(vc.txta.getText());
        double b = Double.parseDouble(vc.txtb.getText());
        if ("add".equals(e.getActionCommand())) {
            vc.txtaresult.setText(String.valueOf(mc.add(a, b)));
        } else if ("sub".equals(e.getActionCommand())) {
            vc.txtaresult.setText(String.valueOf(mc.subtract(a, b)));
        } else if ("mul".equals(e.getActionCommand())) {
            vc.txtaresult.setText(String.valueOf(mc.multiply(a, b)));
        } else if ("div".equals(e.getActionCommand())) {
            vc.txtaresult.setText(String.valueOf(mc.divide(a, b)));
        }
    }
}

