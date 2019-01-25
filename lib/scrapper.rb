require "nokogiri"
require "open-uri"
require "pry"

class Scrapper
	attr_accessor :towns_townhalls_emails_hash 

#######################################################################
#######################################################################
### la classe Scrapper possède un attribut towns_townhalls_emails_hash qui est la valeur de retour de la fonction eponyme.
	def initialize 
		@towns_townhalls_emails_hash = get_towns_townhalls_emails_hash
	end

#######################################################################
#######################################################################
### liste_dpts réunit dans un array toutes les extensions ("/gard.html", "/bouches_du_rhone.html", "...")
##### liste_dpts final en selectionne 3 aléatoirement (on pourrait faire une methode pour /laisser le choix /permettre le choix aléatoire
	def liste_dpts(page)
		liste_dpts = page.css("//tbody//tr//td//a[@class='lientxt']/@href").to_a
		liste_dpts.map! {|k| k.text}
		final_liste_dpts = []
		while final_liste_dpts.size < 3
			final_liste_dpts << liste_dpts[rand(liste_dpts.size-1)]
		end
		final_liste_dpts
	end

#######################################################################
#######################################################################
### get_townhall_urls travaille à partir de la précédente liste (liste_dpts)
##### elle renvoit un array de deux arrays : une liste des noms de communes et une autre, de suffixes ("/28/allainville.html", "...")
####### pour chaque département cette fonction : -ouvre la page correspondante, récupère la liste des communes eventuellement sur plusieurs pages 
######### (nbpagecommunes contient les liens vers les differentes pages listant les communes)
	def get_townhall_urls(liste_dpts,page)
		liste_cmmnes = []
		liste_noms = []
		nbpagescommunes = []
		liste_dpts.map do |lien|
			page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/"+lien))
			nbpagescommunes += page.css("/html/body/table/tbody/tr[3]/td/table/tbody/tr/td[1]/p[4]//a/@href").to_a
			nbpages = 0
			while nbpages < nbpagescommunes.size+1
				if nbpagescommunes.size > 0
					page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/"+nbpagescommunes[nbpages])) 
				end
				liste_cmmnes += page.css("//p/a.lientxt/@href").to_a
				liste_noms += page.css("//p/a.lientxt/text()").to_a.map! {|k| k.text}
				nbpages += 1
			end
		end
		return [liste_noms, liste_cmmnes.map! {|k| k.text}]
	end

#######################################################################
#######################################################################
### la methode de scrapping à proprement parler. à partir de l'array contenant un array de noms et un array d'urls, 
##### cette méthode ouvre les pages correspondantes et range dans un array le résultats (les emails), en affichant une 
####### erreur dans le terminal si elle n'a pas réussi à atteindre la site en question.
######### Elle renvoit une array contenant un hash d'une valeur par ville, dont la clé est le nom de la ville et la valeur l'email associé (ou une string vide).
	def scrapping_master_function(arraydarrays)
		email_array = []
		arraydarrays[1].map do |k|
			begin
					page =  Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/"+k))
					email_array << page.css("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
			rescue StandardError, OpenURI::HTTPError
					puts "ERROR"
			end
		end
		return [arraydarrays[0], email_array].transpose.map {|k| [k].to_h}
	end


#######################################################################
#######################################################################
### Cette méthode  execute la méthode de scrapping et retourne le hash en question.
	def get_towns_townhalls_emails_hash
		page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/"))
		return scrapping_master_function(get_townhall_urls(liste_dpts(page),page))
	end

#######################################################################
#######################################################################
### perform affiche simplement cet array.
	def perform
		puts @towns_townhalls_emails_hash
	end

end

Scrapper.new.perform
