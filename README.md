# Домашнее задание к занятию "`Индексы`" - `Пешкин Евгений`

### Задание 1.
Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

#### Ответ
![Скриншот к заданию 1](https://github.com/SoReX48/12-05.md/blob/main/Индексы/1.png)

### Задание 2.
Выполните explain analyze следующего запроса:

select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id

#### Ответ
![Скриншот к заданию 2](https://github.com/SoReX48/12-05.md/blob/main/Индексы/2.png)

1) перечислите узкие места;
<br/>

#### Ответ
<br/>
1) Nested loop iner join - Объединяемые таблицы через INNER JOIN имеют большое количество строк
<br/>
2) Table scan on p - Сканирование таблицы payment занимает очень много времени
<br/>
3)
<br/> 
Covering index scan on f using idx_title
<br/>
Single-row index lookup on c using PRIMARY
<br/>   
Single-row covering index lookup on i using PRIMARY
<br/>
<br/>
mySQL пытается обнаружить доступные индексы но в результате того что индексов нет время запроса увеличивается так как
запросы не оптимизирован

по запросу:
1) Использование функции DATE в условии WHERE накладываем вычисление на каждую строку таблицы payment
2) Использование оконной функции без явного предназначения приводит к ненужному расходу ресурсов
<br/>
2) оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.
<br/>

#### Ответ
<br/>
Сделаем индексы:
<br/>
CREATE INDEX idx_customer_id ON rental (customer_id);
<br/>
CREATE INDEX idx_inventory_id ON rental (inventory_id);
<br/>
CREATE INDEX idx_film_id ON inventory (film_id);

<br/>
<br/>

![Скриншот к заданию 3](https://github.com/SoReX48/12-05.md/blob/main/Индексы/3.png)
![Скриншот к заданию 4](https://github.com/SoReX48/12-05.md/blob/main/Индексы/4.png)
