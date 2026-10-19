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
            
        }
    }
}
