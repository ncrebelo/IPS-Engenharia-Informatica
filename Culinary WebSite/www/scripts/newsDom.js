/**
 * Class that handles where and how the news section is presented to the user
 * @author Nuno Rebelo - 18022107
 */



/**
 * changes to news sections and shows the approriate content. In this case, news headlines.
 */
function showNewsHeadline(){
    const parent = document.getElementById("newslist")
        while (parent.firstChild) {
            parent.firstChild.remove()
    }

    switchToContent("page_news");
    
    var trnews, tdnews;
    var tablenews = document.getElementById("newslist");
    var tbodynews = document.createElement("tbody");
    
    var auxNews = new News();
    defaultNewsList.splice(defaultNewsList.indexOf(auxNews),1);

    defaultNewsList.forEach(function (auxNews){
        trnews = document.createElement("tr");
        tdnews = document.createElement("td");
    
        var image = document.createElement('img');
        image.setAttribute("src", auxNews.img);
       
        generateTd(tdnews, auxNews.title);
        trnews.appendChild(image);
        
        trnews.appendChild(tdnews);
        tbodynews.appendChild(trnews);
    });
    tablenews.appendChild(tbodynews);
};

