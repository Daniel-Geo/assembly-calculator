#include <QtWidgets/QApplication>
#include <QtWidgets/QWidget>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMessageBox>
#include <limits>
#include <string>

extern "C" int calc(long long a, long long b, char op, long long* out);

int main(int argc, char** argv) {
    QApplication app(argc, argv);

    QWidget win;
    win.setWindowTitle("Assembly Calculator");
    QPalette pal = win.palette();
    pal.setColor(QPalette::Window, Qt::black);
    win.setAutoFillBackground(true);
    win.setPalette(pal);

    auto* grid = new QGridLayout(&win);
    auto* eA   = new QLineEdit();
    auto* eB   = new QLineEdit();
    auto* op   = new QComboBox();
    auto* btn  = new QPushButton("Calculate");
    auto* lbl  = new QLabel("Result: ");

    QPalette palette = lbl->palette();
    palette.setColor(QPalette::WindowText, Qt::white);
    lbl->setPalette(palette);

    eA->setPlaceholderText("First number (int64)");
    eB->setPlaceholderText("Second number (int64)");
    op->addItems({"+", "-", "*", "/"});

    grid->addWidget(eA, 0, 0, 1, 2);
    grid->addWidget(op, 0, 2, 1, 1);
    grid->addWidget(eB, 0, 3, 1, 2);
    grid->addWidget(btn, 1, 1, 1, 3);
    grid->addWidget(lbl, 2, 0, 1, 5);

    QObject::connect(btn, &QPushButton::clicked, [&] {
        bool ok1=false, ok2=false;
        long long a = eA->text().toLongLong(&ok1, 10);
        long long b = eB->text().toLongLong(&ok2, 10);
        if (!ok1 || !ok2) {
            lbl->setText("Error: invalid input");
            return;
        }
        QByteArray s = op->currentText().toLatin1();
        char oper = s.isEmpty() ? 0 : s[0];

        long long out = 0;
        int rc = calc(a, b, oper, &out);
        if (rc == 0) {
            lbl->setText(QString("Result: %1").arg(out));
        } else if (rc == 2) {
            lbl->setText("Error: division by zero");
        } else if (rc == 3) {
            lbl->setText("Error: overflow");
        } else {
            lbl->setText("Error: invalid operator");
        }
    });

    win.resize(480, 140);
    win.show();
    return app.exec();
}