module Jekyll
  module ProjectImageFilters
    def get_img_path(project, filename)
        slug = project['slug']
        dir = @context.registers[:site].config['collections']['projects']['img_path']
        return File.join(dir, slug, filename)
    end

    def get_featured_image_path(project)
        info = project['featured_info']
        if !info then return nil end
        image = info['image']
        if !image then return nil end
        return get_img_path(project, image)
    end

    def _get_project_image_filenames(project)
        dir = @context.registers[:site].config['collections']['projects']['img_path']
        dir = dir[1..-1] # Remove first char (/)
        slug = project['slug']
        path = File.join(dir, slug, '*')
        names = Dir[path]
        return names
    end

    def get_image_paths(project)
        return _get_project_image_filenames(project).map { |e|
            get_img_path(project, File.basename(e))
        }
    end

    def _new_tile(href, image, style)
        return { "href" => href, "image" => image, "style" => style }
    end

    def get_featured_tiles(projects)
        items = projects.map { |item|
            href = item.url
            image = get_featured_image_path(item)
            style = item['tile_style']
            _new_tile(href, image, style)
        }
        return items
    end

    def get_project_tiles(project)
        get_image_paths(project).map { |image|
            _new_tile(image, image, project['tile_style'])
        }
    end

  end
end

Liquid::Template.register_filter(Jekyll::ProjectImageFilters)
