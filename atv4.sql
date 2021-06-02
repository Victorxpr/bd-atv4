create database comercial;
use comercial;
create table comclien(
			n_numeclien int not null auto_increment, 
			c_codiclien varchar(10),
			c_nomeclien varchar(50),
			c_razaclien varchar(50),
			d_dataclien date,
			c_cnpjclien varchar(20),
			c_foneclien varchar(15),
			c_cidaclien varchar(50),
			c_estaclien varchar(50),
			primary key (n_numeclien));
            
            create table comforne(
			n_numeforne int not null auto_increment,
			c_codiforne varchar(10),
			c_nomeforne varchar(50),
			c_razaforne varchar(50),
			c_foneforne varchar(15), 
			primary key(n_numeforne));
create table comprodu(
			n_numeprodu int not null auto_increment,
			c_codiprodu varchar(20),
			c_descprodu varchar(100),
			n_valoprodu float(10,2),
			c_situprodu varchar(1),
			n_numeforne int,
			primary key(n_numeprodu));
            
create table comvenda(
			n_numevenda int not null auto_increment,
			c_codivenda varchar(10),
			n_numeclien int not null,
			n_numeforne int not null,
			n_numevende int not null,
			n_valovenda float(10,2),
			n_descvenda float(10,2),
			n_totavenda float(10,2),
			d_datavenda date,	
			primary key(n_numevenda));
            
create table comvende(
			n_numevende int not null auto_increment,
			c_codivende varchar(10),
			c_nomevende varchar(50),
			c_razavende varchar(50),
			c_fonevende varchar(15),
			n_porcvende float(10,2),
			primary key(n_numevende));
            
create table comivenda(
			n_numeivenda int not null auto_increment,
			n_numevenda  int not null,
			n_numeprodu  int not null,
			n_valoivenda float(10,2),
			n_qtdeivenda int,
			n_descivenda float(10,2),
			primary key(n_numeivenda));


alter table comvenda add constraint fk_comprodu_conforne
			foreign key(n_numeforne)
				references comforne(n_numeforne)
					on delete no action
					on update no action;
                    
alter table comvenda add constraint fk_comvenda_comclien 
			foreign key(n_numeclien) 
				references comclien(n_numeclien)
					on delete no action
					on update no action;
                    
alter table comvenda add constraint fk_comvenda_comvende 
			foreign key(n_numevende) 
				references comvende(n_numevende)
					on delete no action
					on update no action;
                    
                    
alter table comivenda add constraint fk_comivenda_comprodu 
			foreign key(n_numeprodu) 
				references comprodu (n_numeprodu)
					on delete no action 
					on update no action;
					
alter table comvende add n_porcvende float(10,2);
alter table comvenda add n_vcomvenda float(10,2);

	DELIMITER  $$
create trigger tri_vendas_ai
after insert on comivenda
for each row
begin
	
	close busca_itens;
    
    SET vtotal_item = NEW.n_valoivenda * NEW.n_qtdeivenda;
    
	UPDATE comvenda SET n_totavenda = vtotal_itens - vtotal_item
	WHERE n_numevenda = new.n_numevenda;
end$$
delimiter ;clare vtotal_itens float(10,2) DEFAULT 0;
	declare vtotal_item float(10,2) DEFAULT 0;
	declare total_item float(10,2);
    DECLARE qtd_item INT DEFAULT 0;
    DECLARE fimloop INT DEFAULT 0;
    

	declare busca_itens cursor for
		select n_valoivenda, n_qtdeivenda
		from comivenda
		where n_numevenda = new.n_numevenda;
    
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET fimloop = 1;
    
	
	open busca_itens;
		
		itens : loop
            
			IF fimloop = 1 THEN
				LEAVE itens;
			END IF;
        
			fetch busca_itens into total_item, qtd_item;
			
			
			SET vtotal_item = total_item * qtd_item;
			set vtotal_itens = vtotal_itens + vtotal_item;
            
		end loop itens;
CLOSE busca_itens;
    SET vtotal_item = NEW.n_valoivenda * NEW.n_qtdeivenda;
	UPDATE comvenda SET n_totavenda = vtotal_itens - vtotal_item
	WHERE n_numevenda = NEW.n_numevenda;
END$$
DELIMITER ;