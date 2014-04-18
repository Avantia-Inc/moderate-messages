package org.jahia.modules.messages.filter;

import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionFactory;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.filter.AbstractFilter;
import org.jahia.services.render.filter.RenderChain;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.i18n.LocaleContextHolder;

import javax.jcr.NodeIterator;
import javax.jcr.RepositoryException;
import javax.jcr.query.Query;
import javax.jcr.query.QueryManager;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Created by smonier on 08/04/14.
 */


public class messagesList extends AbstractFilter {

    private JCRSessionWrapper getSession() throws RepositoryException {
        return getSession(LocaleContextHolder.getLocale());
    }

    private JCRSessionWrapper getSession(Locale locale) throws RepositoryException {
        return JCRSessionFactory.getInstance().getCurrentUserSession("live", locale);
    }

    static final Logger logger = LoggerFactory.getLogger(messagesList.class);

    public String prepare(RenderContext renderContext, Resource resource, RenderChain chain) {

        // Get SitePath to execute query from it
        String sitePath = renderContext.getMainResource().getNode().getPath().toString();

        final List<JCRNodeWrapper> forumPostlist = new ArrayList<JCRNodeWrapper>();
        final List<JCRNodeWrapper> CommentPostlist = new ArrayList<JCRNodeWrapper>();
        final List<JCRNodeWrapper> blogPostlist = new ArrayList<JCRNodeWrapper>();
        final List<JCRNodeWrapper> allPostlist = new ArrayList<JCRNodeWrapper>();

        logger.info("Query site " + sitePath + " to retrieve all posts");
        try {
            QueryManager qm = getSession().getWorkspace().getQueryManager();
            StringBuilder statement = new StringBuilder("select * from [jnt:post] as post where ISDESCENDANTNODE(post,'" + sitePath + "')  order by post.['jcr:created'] desc");

            Query q = qm.createQuery(statement.toString(), Query.JCR_SQL2);

            NodeIterator ni = q.execute().getNodes();
            while (ni.hasNext()) {
                JCRNodeWrapper nodeWrapper = (JCRNodeWrapper) ni.next();
                if (nodeWrapper.isNodeType("jnt:post")) {
                    if (nodeWrapper.isNodeType("jmix:moderated") && (nodeWrapper.hasProperty("moderated"))) {

                        allPostlist.add(nodeWrapper);
                        logger.info("adding allPostlist");
                    }
                    if (nodeWrapper.getParent().getName().contentEquals("comments") && nodeWrapper.getParent().getParent().isNodeType("jnt:page") && !(nodeWrapper.hasProperty("moderated"))) {
                        CommentPostlist.add(nodeWrapper);
                        logger.info("adding CommentPostlist");
                    }
                    if (nodeWrapper.getParent().isNodeType("jnt:topic") && !(nodeWrapper.hasProperty("moderated"))) {
                        forumPostlist.add(nodeWrapper);
                        logger.info("adding forumPostlist");
                    }
                    if (nodeWrapper.getParent().getParent().isNodeType("jnt:blogPost") && !(nodeWrapper.hasProperty("moderated"))) {
                        blogPostlist.add(nodeWrapper);
                        logger.info("adding blogPostlist");
                    }
                }
            }

            // Save  List in request
            HttpServletRequest request = renderContext.getRequest();
            request.setAttribute("forumPostlist", forumPostlist);
            request.setAttribute("CommentPostlist", CommentPostlist);
            request.setAttribute("blogPostlist", blogPostlist);
            request.setAttribute("allPostlist", allPostlist);

        } catch (RepositoryException e) {
            logger.error("Missing information for Post list Retrieval");
            e.printStackTrace();

        }

        return null;
    }
}